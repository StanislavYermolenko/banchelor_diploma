resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "target-proxy"
  description = "a description"
  url_map     = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "url-map-target-proxy"
  description     = "a description"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name        = "backend"
  port_name   = "customhttp"
  protocol    = "HTTP"
  timeout_sec = 10
  backend {
    group = var.backend_instance_group
  }
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "check-backend"
  request_path       = "/_ah/health"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = 8080
}