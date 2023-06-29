data "google_client_config" "provider" {

}

data "google_container_cluster" "cluster" {
  name     = "${var.project_id}-gke"
  location = var.region
}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    )
  }
}

resource "helm_release" "larademo" {
  name             = "char-larademo"
  chart            = "./charts/larademo"
  namespace        = "defualt"
  create_namespace = true
  recreate_pods    = true

  depends_on = [
    google_container_cluster.primary
  ]
}
