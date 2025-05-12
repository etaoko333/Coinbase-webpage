variable "domain_name" {
  default = "eta-oko.com"
}

variable "subdomain" {
  default = "www"
}

variable "ecr_repo_name" {
  default = "my-react-app"
}

variable "app_image" {
  description = "The Docker image to deploy"
  type        = string
  default     = "851725512876.dkr.ecr.us-west-1.amazonaws.com/coinbase-app:latest"
}
