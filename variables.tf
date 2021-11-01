variable "db_user" {
  sensitive = true
}

variable "db_pswd" {
  sensitive = true
}

variable "db_user_pswd" {
  sensitive = true
}

variable "gce_instance_type" {}

variable "instance_network_tag" {}

variable "image_bucket_name" {}

variable "bucket_location" {}

variable "destroy_policy" {}

variable "instance_network" {}

variable "startup_script" {}

variable "service_account_for_instance" {}

variable "region" {}

variable "project_id" {}

variable "sql_region" {}
