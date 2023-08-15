terraform {
  required_version = ">= 1.2.5"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
