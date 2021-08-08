resource "google_compute_instance_template" "bookshelf_template" {
  name        = var.template_name
  description = "Template is used to create bookshelf app server instances"

  tags = [var.instance_tag]

  machine_type   = var.instance_machine_type
  can_ip_forward = false

  scheduling {
    automatic_restart = false
  }

  disk {
    source_image = var.boot_disc_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.instance_network
  }
  metadata_startup_script = var.startup_script
  service_account {
    email  = var.service_account_for_instance
    scopes = ["cloud-platform"] #storage-ro
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/books/"
    port         = "8080"
  }
}

resource "google_compute_region_instance_group_manager" "bookshelfserver" {
  name = "bookshelfserver-igm"

  base_instance_name = "bookshelf"
  region             = var.igm_region

  version {
    instance_template = google_compute_instance_template.bookshelf_template.id
  }

  named_port {
    name = "http"
    port = "8080"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "bookshelf_autoscaler" {
  name   = "bookshelf-autoscaler"
  region = var.igm_region
  target = google_compute_region_instance_group_manager.bookshelfserver.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 1
    }
  }
}
