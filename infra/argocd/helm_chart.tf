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


# ingress chart
resource "helm_release" "core_ingress" {
  name       = "core-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  skip_crds  = false
  version = "4.14.1"
  namespace = "core-ingress"
  create_namespace = true

  set = [
    {
      name  = "controller.ingressClass"
      value = "core-nginx"
    },
  ]
}


#vault chart
resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  skip_crds  = true
  version = "0.32.0"
  namespace = "vault"
  create_namespace = true

    set = [
    {
      name  = "server.dataStorage.storageClass"
      value = "topolvm-immediate"
    },
    {
      name  = "server.dataStorage.size"
      value = "5Gi"
    },
    {
      name  = "injector.image.tag"
      value = "1.7.2-ubi"
    },
    {
      name  = "injector.agentImage.tag"
      value = "1.21.2-ubi"
    },
    {
      name  = "server.image.tag"
      value = "1.21.2-ubi"
    },
    {
      name  = "injector.securityContext.pod.fsGroup"
      value = "null"
    },
    {
      name  = "injector.securityContext.pod.runAsGroup"
      value = "null"
    },
    {
      name  = "injector.securityContext.pod.runAsUser"
      value = "null"
    },
    {
      name  = "injector.securityContext.container.fsGroup"
      value = "null"
    },
    {
      name  = "injector.securityContext.container.runAsGroup"
      value = "null"
    },
    {
      name  = "injector.securityContext.container.runAsUser"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.pod.fsGroup"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.pod.runAsUser"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.pod.runAsGroup"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.container.fsGroup"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.container.runAsUser"
      value = "null"
    },
    {
      name  = "server.statefulSet.securityContext.container.runAsGroup"
      value = "null"
    },
    {
      name  = "csi.agent.securityContext.runAsUser"
      value = "null"
    },
    {
      name  = "csi.agent.securityContext.runAsGroup"
      value = "null"
    },
  ]
}

