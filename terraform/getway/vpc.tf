# VPC
resource "google_compute_network" "dev_vpc" {
  name                    = "${var.project_id}-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "dev_subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.dev_vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_address" "dev_subnet_and_address" {
  name         = "my-internal-address"
  subnetwork   = google_compute_subnetwork.dev_subnet.id
  address_type = "INTERNAL"
  address      = "10.10.0.100"
  region       = var.region
}