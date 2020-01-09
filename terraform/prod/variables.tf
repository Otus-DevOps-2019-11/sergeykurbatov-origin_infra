variable project {
  description = "Project ID"
}
variable app_name {
  description = "Application name"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable public_key_path1 {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable public_key_path2 {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable public_key_path3 {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key {
  description = "Path to the private key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable service_port_name {
  default = "tcp-9292"
}
variable service_port {
  default = 9292
}
variable instance_count {
  type = number
  default = 1
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-db-base"
}
variable install_app {
  description = "Decides to install or not install reddit ruby app"
  default     = false
}
