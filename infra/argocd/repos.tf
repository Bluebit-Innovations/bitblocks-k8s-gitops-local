#repos
# Public Git repository
resource "argocd_repository" "public_bitblock_repo" {
  repo = "git@github.com:Bluebit-Innovations/bitblocks-k8s-gitops-local.git"
  project = "default"
  name = "bitblocks-k8s-gitops-local"
  depends_on = [helm_release.argocd]
}

resource "argocd_repository" "public_bitblock_prometheus_stack_repo" {
  repo = "https://prometheus-community.github.io/helm-charts"
  project = "observability"
  name = "kube-prometheus-stack"
  depends_on = [helm_release.argocd]
}

resource "argocd_repository" "public_ingress_nginx_repo" {
  repo = "https://kubernetes.github.io/ingress-nginx"
  project = "default"
  name = "ingress-nginx"
  type = "helm"
  depends_on = [helm_release.argocd]
}