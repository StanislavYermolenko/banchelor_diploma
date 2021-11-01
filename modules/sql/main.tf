resource "google_sql_database_instance" "bookshelf_db" {
  name                = var.db-instance_name
  database_version    = var.db_version
  root_password       = var.db_password
  region              = var.sql_region
  deletion_protection = false
  settings {
    tier = var.machine_type
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.selected_network
    }
  }
}

resource "google_sql_database" "bookshelf_db" {
  name     = var.bookshelf_database_name
  instance = google_sql_database_instance.bookshelf_db.id
}

resource "google_sql_user" "users" {
  name     = var.db_user_name
  instance = google_sql_database_instance.bookshelf_db.name
  password = var.db_user_password
}
