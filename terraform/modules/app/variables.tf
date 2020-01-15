variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable private_key {
  description = "Path to private key file for ssh connection"
  default = "~/.ssh/appuser"
}
variable db_ip {
}
variable install_app {
  default = false
}
