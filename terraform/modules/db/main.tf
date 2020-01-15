resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-db"]
  # Family image
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  # Networking
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  connection {
    type        = "ssh"
    host        = google_compute_instance.db.network_interface.0.access_config.0.nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    inline = [<<EOF
      set -e
      sudo sed -i 's/bindIp: 127.0.0.1/bindIp: ${self.network_interface.0.network_ip}/g' /etc/mongod.conf
      sudo systemctl restart mongod
      EOF
    ]
  }
}
