terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.23.0"
    }
  }
  required_version = ">= 0.13"
}