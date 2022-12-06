terraform {
  required_version = ">= 0.14"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.2"
    }
  }
}
