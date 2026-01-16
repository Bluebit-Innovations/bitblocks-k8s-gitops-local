

#apps
resource "argocd_application" "umbrella_app" {
  metadata {
    name      = "umbrella-app"
    namespace = "argocd"
    labels = {
      test = "true"
    }
  }


  spec {

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

    # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
        }

    project = "testproject"
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    source {
      repo_url        = "https://github.com/Bluebit-Innovations/bitblocks-k8s-gitops-local"
      path           = "ops/argocd/umbrella-app"
      target_revision = "main"
    }
  }

  depends_on = [helm_release.argocd, argocd_project.testproject, argocd_repository.public_bitblock_repo]
}


resource "argocd_application" "observability" {
  metadata {
    name      = "observability"
    namespace = "argocd"
    labels = {
      project-name = "k8s-local"
      app = "observability"
    }
  }
  
  spec {
    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

    # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
        }

    project = "k8s-local"
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    source {
      repo_url        = "https://github.com/Bluebit-Innovations/bitblocks-k8s-gitops-local"
      path           = "ops/argocd/observability-app"
      target_revision = "main"
    }
  }

  depends_on = [helm_release.argocd, argocd_project.testproject, argocd_repository.public_bitblock_repo]
}