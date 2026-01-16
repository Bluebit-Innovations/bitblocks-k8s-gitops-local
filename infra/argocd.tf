#repos
# Public Git repository
resource "argocd_repository" "public_bitblock_repo" {
  repo = "git@github.com:Bluebit-Innovations/bitblocks-k8s-gitops-local.git"
  project = "default"
  depends_on = [helm_release.argocd]
}

#projects
resource "argocd_project" "testproject" {
  metadata {
    name      = "testproject"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
    annotations = {
        project-name = "testproject"
    }
  }

  spec {
    description = "Project to test how an argocd project works"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }


    role {
      name = "testrole"
      policies = [
        "p, proj:testproject:testrole, applications, override, testproject/*, allow",
        "p, proj:testproject:testrole, applications, sync, testproject/*, allow",
        "p, proj:testproject:testrole, clusters, get, testproject/*, allow",
        "p, proj:testproject:testrole, repositories, create, testproject/*, allow",
        "p, proj:testproject:testrole, repositories, delete, testproject/*, allow",
        "p, proj:testproject:testrole, repositories, update, testproject/*, allow",
        "p, proj:testproject:testrole, logs, get, testproject/*, allow",
        "p, proj:testproject:testrole, exec, create, testproject/*, allow",
      ]
    }

    role {
      name = "anotherrole"
      policies = [
        "p, proj:testproject:anotherrole, applications, get, testproject/*, allow",
        "p, proj:testproject:anotherrole, applications, sync, testproject/*, deny",
      ]
    }

    sync_window {
      kind         = "allow"
      applications = ["api-*"]
      clusters     = ["*"]
      namespaces   = ["*"]
      duration     = "24h"
      schedule     = "10 1 * * *"
      manual_sync  = true
    }
    sync_window {
      kind         = "deny"
      applications = ["foo"]
      clusters     = ["in-cluster"]
      namespaces   = ["default"]
      duration     = "72h"
      schedule     = "22 1 5 * *"
      manual_sync  = false
      timezone     = "Europe/London"
    }

    signature_keys = []
  }
  depends_on = [helm_release.argocd]
}

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