terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_pet" "app_name" {
  length    = 2 # Number of words
  separator = "-"
}

output "app_name" {
  value = random_pet.app_name.id
}
