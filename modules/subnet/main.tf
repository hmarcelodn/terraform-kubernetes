resource "azurerm_subnet" "default" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.address_prefix}"
}

output "kubernetes_nodes_subnet_id" {
  value = "${azurerm_subnet.default.id}"
}

output "subnet_name" {
  value = "${azurerm_subnet.default.name}"
}
