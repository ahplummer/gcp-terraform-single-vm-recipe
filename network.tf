resource "google_compute_network" "vpc_network" {
  project                 = var.GCP_PROJECT
  name                    = var.VPC_NAME
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "fw" {
  name    = "fw-${random_id.instance_id.hex}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["5000","22"]
  }
}