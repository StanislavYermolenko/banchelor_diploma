resource "google_compute_network" "bookshelf_vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

resource "google_compute_global_address" "private_ip_address" {

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.bookshelf_vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {

  network                 = google_compute_network.bookshelf_vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_firewall" "ssh_rule_IAP" {
  name          = "boockshelf-ssh-firewall-rule"
  network       = google_compute_network.bookshelf_vpc_network.name
  source_ranges = ["35.235.240.0/20"]
  target_tags   = [var.instance_tag]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "http_rule" {
  name = "bookshelf-http-firewall-rule"
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = [var.instance_tag]
  network     = google_compute_network.bookshelf_vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}