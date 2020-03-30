output "internal_ip_address_test_ubuntu" {
  value = "${yandex_compute_instance.test_ubuntu.network_interface.0.ip_address}"
}

output "external_ip_address_test_ubuntu" {
  value = "${yandex_compute_instance.test_ubuntu.network_interface.0.nat_ip_address}"
}
