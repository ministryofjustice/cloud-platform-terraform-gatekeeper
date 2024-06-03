terraform {
  required_version = ">= 1.2.5"
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.2"
    }
  }
}
