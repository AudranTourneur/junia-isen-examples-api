terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }
  }
}

variable "url" {
  type = string
}

data "http" "endpoint" {
  url    = var.url
  method = "GET"
}
