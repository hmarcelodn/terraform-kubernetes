variable "resource_group_name" {
    type = "string",
    description = "Resources Group"
}

variable "vnet_name" {
    type = "string",
    description = "Virtual Network Name"
}

variable "environment_name" {
    type = "string",
    description = "Tag Environment"
}

variable "address_space" {
    type = "string"
    description = "Address Space for VNET"
}

variable "network_location" {
    type = "string"
    description = "Datacenter"
}
