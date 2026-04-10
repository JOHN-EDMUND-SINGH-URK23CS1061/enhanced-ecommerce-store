variable "app_name" {
  description = "Name of the eCommerce application"
  type        = string
  default     = "enhanced-ecommerce-store"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "product_service_image" {
  description = "Docker image for product service"
  type        = string
  default     = "ecommerce-product-service:latest"
}

variable "order_service_image" {
  description = "Docker image for order service"
  type        = string
  default     = "ecommerce-order-service:latest"
}

variable "frontend_image" {
  description = "Docker image for frontend"
  type        = string
  default     = "ecommerce-frontend:latest"
}

variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "ecommerce-network"
}

variable "ports" {
  description = "Port mappings for services"
  type = map(number)
  default = {
    frontend       = 3000
    product_service = 3001
    order_service   = 3002
  }
}
