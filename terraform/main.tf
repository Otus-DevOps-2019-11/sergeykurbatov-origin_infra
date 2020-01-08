terraform {
  # Версия terraform
  required_version = "0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "2.15"


  # ID проекта
  project = var.project

  region = var.region
}
resource "google_compute_instance" "app" {
  count        = var.instance_count
  name         = "${var.app_name}${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = [var.app_name]
  # Family image
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  # Networking
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}\nappuser3:${file(var.public_key_path)}"
  }
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key)
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
resource "google_compute_project_metadata_item" "app" {
  key   = "ssh-keys"
  value = "appuser_web:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNfSDsL6ZnjSnHhEbyLMuayjTuNRt+Iy49+Rh1idivrBcRXwaApOQ7+kN9tCg4vtP1CRaJV9zagrvnQkwmE/PQSsr4wfkkkW8mSj70nkeeUFswIisedl7Dvhx/CQw+95nnkBJEJGFfQ3rjLpyXPPd9j3dohqFyR8ogL27eOr2hCSiUmbZE7aF6VGy5JsOXoPTBFrsG6f8eAlTzn9VyK6iGeLD+xPG2UxJljz+t9dh84H4EHDKsjwAAscu2l5NJxiwIiv1dsF/fX+FSGvrSsx7Ke+WNoCkMMDg40+LSXLj0Tb0ennyXQ4kZ4G2ybBHxX+cf5HqEOQ8HzmUnnzgVjoH5 appuser_web"
}
