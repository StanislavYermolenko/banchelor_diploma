resource "google_storage_bucket" "image_storage" {
  name          = var.image_bucket_name
  location      = var.bucket_location
  force_destroy = var.destroy_policy
}

resource "google_storage_bucket_iam_member" "allusers" {
  bucket = google_storage_bucket.image_storage.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}