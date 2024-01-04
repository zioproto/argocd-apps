# Create IP for Ingress
data azurerm_resource_group "argocd" {
  name = var.rg
  depends_on = [  ]
}

resource "azurerm_public_ip" "argocd" {
  name                = "argocd"
  location            = data.azurerm_resource_group.argocd.location
  resource_group_name = data.azurerm_resource_group.argocd.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "helm_release" "argocd" {

  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.image.tag"
    value = "v2.7.15"
  }

#because I can't pass "- --insecure" directly using set{}
  values = [
    file("${path.module}/chart/argocd/values.yaml")
  ]

}

resource "helm_release" "rootapp" {

  depends_on = [helm_release.argocd]


  name             = "rootapp"
  chart            = "${path.module}/chart/rootapp"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "bootstrap.repo_path"
    value = var.bootstrap_repo_path
  }

  set {
    name  = "bootstrap.repo_url"
    value = var.bootstrap_repo_url
  }

  set {
    name  = "bootstrap.repo_branch"
    value = var.bootstrap_repo_branch
  }
  set {
    name = "ingress.host"
    value = "${azurerm_public_ip.argocd.ip_address}.nip.io"
  }

}