terraform {
  backend "gcs" {
    bucket = "terraform-state230721"
    prefix = "terraform/state"
  }
}
