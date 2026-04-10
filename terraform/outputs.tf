output "docker_network_id" {
  description = "ID of the Docker network"
  value       = docker_network.ecommerce_network.id
}

output "product_service_container_id" {
  description = "ID of the product service container"
  value       = docker_container.product_service.id
}

output "order_service_container_id" {
  description = "ID of the order service container"
  value       = docker_container.order_service.id
}

output "frontend_container_id" {
  description = "ID of the frontend container"
  value       = docker_container.frontend.id
}

output "kubernetes_namespace_name" {
  description = "Name of the Kubernetes namespace"
  value       = kubernetes_namespace.ecommerce.metadata[0].name
}

output "application_urls" {
  description = "URLs for accessing the application"
  value = {
    frontend        = "http://localhost:${var.ports["frontend"]}"
    product_service = "http://localhost:${var.ports["product_service"]}/products"
    order_service   = "http://localhost:${var.ports["order_service"]}/orders"
  }
}

output "container_status" {
  description = "Status of all containers"
  value = {
    product_service = docker_container.product_service.name
    order_service   = docker_container.order_service.name
    frontend        = docker_container.frontend.name
  }
}
