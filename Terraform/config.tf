resource "kubernetes_namespace" "test" {
  metadata {
    name = "nodejs"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nodejs"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "NodeJS"
      }
    }
    template {
      metadata {
        labels = {
          app = "NodeJS"
        }
      }
      spec {
        container {
          image = "${var.image_name}:latest"
          name  = "nodejs-container"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "nodejs"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 3000
      target_port = 3000
    }
  }
}
