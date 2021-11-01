terraform {
  backend "gcs" {
    bucket = "terraform-state080821"
    prefix = "terraform/state"
  }
}
