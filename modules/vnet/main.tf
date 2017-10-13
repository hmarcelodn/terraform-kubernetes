resource "azurerm_virtual_network" "default" {
  name          = "${var.vnet_name}"
  resource_group_name = "${var.resource_group_name}"
  address_space = ["${var.address_space}"]
  location      = "${var.network_location}"

  tags {
    environment = "${var.environment_name}"
  }  
}

output "resource_location_name" {
  value = "${azurerm_virtual_network.default.location}"
}

output "virtual_network_name" {
  value = "${azurerm_virtual_network.default.name}"
}
