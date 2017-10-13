variable "master_first_consecutive_static_ip" {
    type = "string",
    description = "Master First Consecutive Static IP"    
}

variable "subcription_id" {
    type = "string",
    description = "Subscription Id"    
}

variable "agent_pool_count" {
    type = "string",
    description = "Agent Pool Count"    
}

variable "nodes_subnet_id" {
    type = "string",
    description = "Kubernetes Nodes Subnet ID"    
}

variable "master_subnet_id" {
    type = "string",
    description = "Kubernetes Masters Subnet ID"    
}

###
variable "subscription_id" {
    type        = "string"
    description = "Subscription"
}
    
variable "dns_prefix" {
    type        = "string"
    description = "DNS Cluster Prefix"
}

variable "location_name" {
    type        = "string"
    description = "Location Cluster Name"
}

variable "cluster_resource_group" {
    type        = "string"
    description = "Resource Group for ACS-ENGINE cluster resources"
}

variable "agents_subnet_name" {
    type        = "string"
    description = "Subnet Name used by Kubernetes Agents"
}

variable "masters_subnet_name" {
    type        = "string"
    description = "Subnet Name used by Kubernetes masters"
}

variable "vnet_name" {
    type        = "string"
    description = "Virtual Net Name"
}

variable "depends_on" {
    type = "string"
}

variable "cluster_k8s_resource_group" {
    type = "string"
}
