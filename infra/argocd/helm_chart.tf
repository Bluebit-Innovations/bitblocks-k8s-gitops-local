#Core Services deployed into the cluster not maintained by argocd.

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


# core ingress chart for core services not deployed by arogcd
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
    {
      name  = "controller.ingressClassResource.name"
      value = "core-nginx"
    },
    {
      name  = "controller.service.type"
      value = "NodePort"
    },
    {
      name  = "controller.image.runAsUser"
      value = "null"
    },
    {
      name  = "controller.image.runAsGroup"
      value = "null"
    },
    {
      name  = "controller.containerPort.http"
      value = "8080"
    },
    {
      name  = "controller.containerPort.https"
      value = "8443"
    },
    {
      name  = "controller.containerSecurityContext.runAsUser"
      value = "null"
    },
    {
      name  = "controller.containerSecurityContext.runAsGroup"
      value = "null"
    },
    {
      name  = "controller.admissionWebhooks.createSecretJob.securityContext.runAsUser"
      value = "null"
    },
    {
      name  = "controller.admissionWebhooks.createSecretJob.securityContext.runAsGroup"
      value = "null"
    },
    {
      name  = "controller.admissionWebhooks.patchWebhookJob.securityContext.runAsUser"
      value = "null"
    },
    {
      name  = "controller.admissionWebhooks.patchWebhookJob.securityContext.runAsGroup"
      value = "null"
    },
    # {
    #   name  = "controller.admissionWebhooks.createSecretJob.securityContext.capabilities.add"
    #   value = "NET_BIND_SERVICE"
    # },
  

    
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


resource "helm_release" "certmanager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  skip_crds  = true
  version = "1.19.2"
  namespace = "cert-manager"
  create_namespace = true

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    },
  ]
}

resource "helm_release" "dex" {
  name       = "dex"
  repository = "https://charts.dexidp.io"
  chart      = "dex"
  skip_crds  = true
  version = "0.24.0"
  namespace = "dex"
  wait = true
  create_namespace = true
  force_update = true
  values = [
    yamlencode({

      config = {
        issuer = "https://api.crc.testing:30678"
        enablePasswordDB = true

        storage = {
          type = "kubernetes"
          config = {
            inCluster = true
          }
        }

        web = {
          https = "0.0.0.0:5554"
          tlsCert = "/etc/dex/tls/tls.crt"
          tlsKey = "/etc/dex/tls/tls.key"
        }

        connectors = [
          {
            type = "github"
            id = "github" 
            name = "Github"
            config = {
              clientID = var.github_client_id
              clientSecret = var.github_client_secret
              redirectURI = "https://api.crc.testing:30678/callback"
            }
          }
        ]

        staticClients = [
          {
            id     = "kubernetes"
            name   = "Kubernetes"
            # Generate a random secret: openssl rand -base64 32
            secret = var.kubernetes_client_secret
            redirectURIs = [
              "http://localhost:8000",      # For kubectl oidc-login plugin
              "http://localhost:18000",     # Alternative port
              "urn:ietf:wg:oauth:2.0:oob"  # For out-of-band flow
            ]
          }
        ]

        oauth2 = {
          skipApprovalScreen = true
        }
        
        # Your connectors, static clients, etc.
      }

      # Enable HTTPS
      https = {
        enabled = true
      }

      # Expose as NodePort
      service = {
        type = "NodePort"
        ports = {
          https = {
            port       = 5554
            nodePort   = 30678
          }
        }
      }

      volumes = [
        {
          name = "tls"
          secret = {
            secretName = "dex-tls-secret"
          }
        }
      ]
      volumeMounts = [
        {
          name      = "tls"
          mountPath = "/etc/dex/tls"
        }
      ]
    })
  ]

}

