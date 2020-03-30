resource "yandex_compute_instance" "test_ubuntu" {
  name                      = "ubuntu-18"
  description               = "test instance"
  allow_stopping_for_update = true

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 10  # Baseline performance for a core, set as a percen
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      # CentOs 7
      image_id    = "fd83869rbingor0in0ui"
      name        = "disk-root"
      description = "Disk for the root"
      size        = var.instance_root_disk
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.test-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./ssh_key.pem")}"
  }

  labels = {
    environment = "test"
  }
}
