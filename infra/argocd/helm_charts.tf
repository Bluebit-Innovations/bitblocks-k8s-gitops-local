resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  skip_crds  = true
  version = "9.3.3"
  namespace = "argocd"
  create_namespace = true

  set = [
    {
      name  = "redis.securityContext.runAsUser"
      value = "null"
    },
    {
      name  = "crds.install"
      value = "true"
    },
    {
      name  = "crds.keep"
      value = "false"
    },
  ]
}
