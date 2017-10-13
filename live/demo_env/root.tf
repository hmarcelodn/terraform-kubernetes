################################################################################################
###                     Configuration Section Azure - Terraform                              ###
################################################################################################

# Subscription
variable "subscription_id"                    { default = "SUBCRIPTION_ID_HERE" }
variable "client_id"                          { default = "CLIENT_ID_HERE" }
variable "client_secret"                      { default = "CLIENT_SECRET_HERE" }
variable "tenant_id"                          { default = "TENANT_ID_HERE" }

# Cluster Config
variable "cluster_resource_group_name"        { default = "bsf_demo_k8s_resources" }
variable "resource_group_location"            { default = "South Central US" }
variable "resource_group_location_short"      { default = "southcentralus" }
variable "cluster_k8s_resource_group"         { default = "bsf_demo_k8s" }

# Networking
variable "vnet_name"                          { default = "vnet_bsf" }
variable "vnet_address_space"                 { default = "10.0.32.0/19" }
variable "agents_subnet_prefix"               { default = "10.0.38.0/24" }
variable "agents_subnet_name"                 { default = "k8s-nodes-subnet" }
variable "masters_subnet_prefix"              { default = "10.0.39.0/24" }
variable "masters_subnet_name"                { default = "k8s-masters-subnet" }
variable "master_first_consecutive_static_ip" { default = "10.0.39.5" }
variable "agent_pool_count"                   { default = "1" }
variable "dns_prefix"                         { default = "bsf-demo-cluster" }

# Tag Info
variable "environment_tag"                    { default = "demo" }

################################################################################################
###                     Deployment Section Azure - Terraform                                 ###
################################################################################################

# Automation subscription
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Main Resource Group
module "resource_group" {
    source                  = "../../modules/resource-group"
    resource_group_name     = "${var.cluster_resource_group_name}",
    resource_group_location = "${var.resource_group_location}"
}

# Virtual Net
# Main Module
module "vnet" {
    source                   = "../../modules/vnet",
    vnet_name                = "${var.vnet_name}",
    environment_name         = "${var.environment_tag}",
    resource_group_name      = "${module.resource_group.resource_group_name}"
    address_space            = "${var.vnet_address_space}"
    network_location         = "${var.resource_group_location}"
}

# nodes Subnet
# DependsOn: vnet
module "kubernetes_subnet" {
    source                   = "../../modules/subnet",
    virtual_network_name     = "${module.vnet.virtual_network_name}",
    resource_group_name      = "${module.resource_group.resource_group_name}",
    address_prefix           = "${var.agents_subnet_prefix}",
    subnet_name              = "${var.agents_subnet_name}"
}

# masters Subnet
# DependsOn: vnet
module "masters_subnet" {
    source                   = "../../modules/subnet",
    virtual_network_name     = "${module.vnet.virtual_network_name}",
    resource_group_name      = "${module.resource_group.resource_group_name}",
    address_prefix           = "${var.masters_subnet_prefix}",
    subnet_name              = "${var.masters_subnet_name}"
}

# Kubernetes cluster definition creation
module "kubernetes_cluster" {
    source                             = "../../modules/kubernetes-cluster"
    master_first_consecutive_static_ip = "${var.master_first_consecutive_static_ip}"
    subcription_id                     = "${var.subscription_id}"
    agent_pool_count                   = "${var.agent_pool_count}"
    nodes_subnet_id                    = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.virtual_network_name}/subnets/${module.kubernetes_subnet.subnet_name}"
    master_subnet_id                   = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.virtual_network_name}/subnets/${module.masters_subnet.subnet_name}"
    dns_prefix                         = "${var.dns_prefix}"
    subscription_id                    = "${var.subscription_id}"
    location_name                      = "${var.resource_group_location_short}"
    cluster_resource_group             = "${module.resource_group.resource_group_name}"
    agents_subnet_name                 = "${module.kubernetes_subnet.subnet_name}"
    masters_subnet_name                = "${module.masters_subnet.subnet_name}"
    vnet_name                          = "${module.vnet.virtual_network_name}"
    depends_on                         = "${module.masters_subnet.subnet_name}"    
    cluster_k8s_resource_group         = "${var.cluster_k8s_resource_group}"
}
