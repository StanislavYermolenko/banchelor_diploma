locals {
  sa_member = "serviceAccount:${google_service_account.instance_service_account.email}"
}

resource "google_service_account" "instance_service_account" {
  account_id = var.instance_servaccount_id
}

resource "google_project_iam_member" "storage_object_admin" {
  role   = "roles/storage.objectAdmin"
  member = local.sa_member
}

resource "google_project_iam_member" "cloudsql_client" {
  role   = "roles/cloudsql.client"
  member = local.sa_member
}

resource "google_project_iam_member" "compute_network_user" {
  role   = "roles/compute.networkUser"
  member = local.sa_member
}

resource "google_project_iam_member" "errorreporting_writer" {
  role   = "roles/logging.logWriter"
  member = local.sa_member
}

resource "google_project_iam_member" "pubsub_editor" {
  role   = "roles/pubsub.editor"
  member = local.sa_member
}

resource "google_project_iam_member" "monitoring_metric_writer" {
  role   = "roles/monitoring.metricWriter"
  member = local.sa_member
}

resource "google_project_iam_member" "source_reader" {
  role   = "roles/source.reader"
  member = local.sa_member
}