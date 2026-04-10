terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.0"
}

provider "docker" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "local" {}

# Create a Docker network for the eCommerce application
resource "docker_network" "ecommerce_network" {
  name = "ecommerce-network"
  driver = "bridge"
}

# Product Service Docker Container
resource "docker_container" "product_service" {
  name  = "ecommerce-product-service"
  image = "ecommerce-product-service:latest"
  
  networks_advanced {
    name = docker_network.ecommerce_network.name
  }
  
  ports {
    internal = 3001
    external = 3001
  }
  
  env = [
    "PORT=3001",
    "NODE_ENV=production"
  ]
  
  restart = "unless-stopped"
}

# Order Service Docker Container
resource "docker_container" "order_service" {
  name  = "ecommerce-order-service"
  image = "ecommerce-order-service:latest"
  
  networks_advanced {
    name = docker_network.ecommerce_network.name
  }
  
  ports {
    internal = 3002
    external = 3002
  }
  
  env = [
    "PORT=3002",
    "PRODUCT_SERVICE_URL=http://product-service:3001",
    "NODE_ENV=production"
  ]
  
  restart = "unless-stopped"
}

# Frontend Docker Container
resource "docker_container" "frontend" {
  name  = "ecommerce-frontend"
  image = "ecommerce-frontend:latest"
  
  networks_advanced {
    name = docker_network.ecommerce_network.name
  }
  
  ports {
    internal = 80
    external = 3000
  }
  
  restart = "unless-stopped"
}

# Kubernetes Namespace
resource "kubernetes_namespace" "ecommerce" {
  metadata {
    name = "ecommerce"
    labels = {
      name = "ecommerce"
      app = "enhanced-ecommerce-store"
    }
  }
}

# Local file for deployment configuration
resource "local_file" "deployment_config" {
  content = templatefile("${path.module}/deployment-config.tpl", {
    namespace = kubernetes_namespace.ecommerce.metadata[0].name
    product_service_port = 3001
    order_service_port = 3002
    frontend_port = 80
  })
  filename = "${path.module}/generated-deployment.yml"
}
