variable "namespace" {
  type        = string
  description = "ArgoCD namespaceo"
  default     = "argocd"
}


variable "bootstrap_repo_url" {
  type        = string
  description = "ArgoCD bootstrap repo"
  default     = ""
}

variable "bootstrap_repo_path" {
  type        = string
  description = "ArgoCD bootstrap repo folder"
  default     = ""
}

variable "bootstrap_repo_branch" {
  type        = string
  description = "ArgoCD bootstrap repo branch"
  default     = ""
}



variable "rg" {
  description = "Resource Group"
}