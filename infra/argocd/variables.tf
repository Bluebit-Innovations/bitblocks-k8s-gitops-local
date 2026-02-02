variable "github_client_id" {
  description = "GitHub OAuth App Client ID"
  type        = string
  sensitive   = true
}

variable "github_client_secret" {
  description = "GitHub OAuth App Client Secret"
  type        = string
  sensitive   = true
}

variable "kubernetes_client_secret" {
  description = "Kubernetes OIDC client secret"
  type        = string
  sensitive   = true
}