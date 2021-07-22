resource "random_id" "db_name_suffix" {
  byte_length = 5
}

module "bucket" {
  source            = "./modules/bucket"
  image_bucket_name = "tf-image-storage-bucket"
  bucket_location   = "US"
  destroy_policy    = "true"
}

module "in_group" {
  source           = "./modules/in_group"
  instance_network = module.network.bookshelf_vpc.id
  boot_disc_image  = "debian-cloud/debian-9"
  startup_script = templatefile("?????????????", {
    db_connect   = module.sql.connection_name,
    bucket       = module.bucket.storage_bucket.name,
    db_user_name = var.db_user,
    db_pass      = var.db_user_pswd
  })
  service_account_for_instance = module.serv_account.custom_instance_service_account
  template_name                = "boockshelf-template"
  instance_machine_type        = var.gce_instance_type
  igm_region                   = "us-central1"
  instance_tag                 = var.instance_network_tag
}

module "loadbalancer" {
  source                 = "./modules/loadbalancer"
  backend_instance_group = module.instance_group.instance_grp
}

module "net" {
  source       = "./modules/net"
  vpc_name     = "bookshelf-vpc-tf"
  instance_tag = var.instance_network_tag
}

module "sql" {
  source                  = "./modules/sql"
  db_version              = "MYSQL_5_7"
  db-instance_name        = "bookshelf-db-tf-${random_id.db_name_suffix.hex}"
  db_password             = var.db_pswd
  db_user_name            = var.db_user
  db_user_password        = var.db_user_pswd
  bookshelf_database_name = "bookshelf"
  machine_type            = "db-n1-standard-2"
  selected_network        = module.network.bookshelf_vpc.id
  depends_on              = [module.network]
}



module "nat" {
  source           = "./modules/nat"
  selected_network = module.network.bookshelf_vpc.id
}

module "serv_acc" {
  source                  = "./modules/serv_acc"
  instance_servaccount_id = "bookshelf-sa-1"
}



