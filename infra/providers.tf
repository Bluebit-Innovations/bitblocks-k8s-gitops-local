terraform {
  required_providers {
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.12.5"
    }
  }
}


provider "helm" {

  kubernetes = {
    config_path = "~/.kube/config"
    config_context = "microshift"
  }
}

# Exposed ArgoCD API - authenticated using `username`/`password`
provider "argocd" {
  use_local_config = true
#   context = "microshift"
}