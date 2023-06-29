terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.63.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "google" {
  #credentials = file(var.credentials_file)

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  network    = google_compute_network.dev_vpc.name
  subnetwork = google_compute_subnetwork.dev_subnet.name

  # Enabling Autopilot for this cluster
  enable_autopilot = true
}
# cloud posgratesql
resource "google_sql_database_instance" "main" {
  name             = "${var.project_id}-db"
  database_version = "${var.dbversion}"
  region           = var.region
  #private_ip_address = "10.10.0.200"
  #depends_on = [google_compute_network.dev_vpc]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value           = "0.0.0.0/0"
        name            = "allow-all"
        expiration_time = "2099-01-01T00:00:00.000Z"
      }
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "billing"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "users" {
  name     = "dustin"
  instance = google_sql_database_instance.main.name
  password = "qazwsxp123"
}