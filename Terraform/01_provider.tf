provider "kubernetes" {
  config_path = var.host

  client_certificate     = "var.client_cert"
  client_key             = "var.client_key"
  cluster_ca_certificate = "var.ca_cert"
}
