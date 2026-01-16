
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


resource "argocd_project" "k8s-local" {
  metadata {
    name      = "k8s-local"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
    annotations = {
        project-name = "k8s-local"
    }
  }

  spec {
    description = "This projeect is dedicate to deployment of applications into various local k8s clusters(microshift,kind,k3s etc)"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }


    # role {
    #   name = "testrole"
    #   policies = [
    #     "p, proj:k8s-local:testrole, applications, override, testproject/*, allow",
    #     "p, proj:testproject:testrole, applications, sync, testproject/*, allow",
    #     "p, proj:testproject:testrole, clusters, get, testproject/*, allow",
    #     "p, proj:testproject:testrole, repositories, create, testproject/*, allow",
    #     "p, proj:testproject:testrole, repositories, delete, testproject/*, allow",
    #     "p, proj:testproject:testrole, repositories, update, testproject/*, allow",
    #     "p, proj:testproject:testrole, logs, get, testproject/*, allow",
    #     "p, proj:testproject:testrole, exec, create, testproject/*, allow",
    #   ]
    # }

    # role {
    #   name = "anotherrole"
    #   policies = [
    #     "p, proj:testproject:anotherrole, applications, get, testproject/*, allow",
    #     "p, proj:testproject:anotherrole, applications, sync, testproject/*, deny",
    #   ]
    # }

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
