output "private_ip" {
  value = "${azurerm_network_interface.dev.private_ip_address}"
}
