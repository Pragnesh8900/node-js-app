provider "kubernetes" {
  host = var.host

  client_certificate     = "${base64decode(var.client_cert)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.ca_cert)}"
}
