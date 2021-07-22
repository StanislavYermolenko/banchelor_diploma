terraform {
  backend "gcs" {
    bucket = "bookshelf-tf-state-main"
    prefix = "terraform/state"
  }
}