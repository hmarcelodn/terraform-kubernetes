# Create Kubernetes
data "template_file" "kubernetes" {
  template = "${file("../../templates/kubernetes.json.tpl")}"

  vars {
    master_subnet_id = "${var.master_subnet_id}"
    nodes_subnet_id = "${var.nodes_subnet_id}"
    master_first_consecutive_static_ip = "${var.master_first_consecutive_static_ip}"
    agent_pool_count  = "${var.agent_pool_count}"    
  }
}

# Create Cluster Definition File
resource "null_resource" "kubernetes_cluster_definition" {
  provisioner "local-exec" {
    command = "cat > kubernetes.json <<EOL\n${join(",\n", data.template_file.kubernetes.*.rendered)}\nEOL"
  }

  depends_on = ["data.template_file.kubernetes"]
}

# Template acs-engine execution
data "template_file" "acs_engine" {
  template = "${file("../../templates/cluster_deployment.sh.tpl")}"

  vars {
    subscription_id             = "${var.subscription_id}"
    dns_prefix                  = "${var.dns_prefix}"
    location_name               = "${var.location_name}" 
    cluster_resource_group      = "${var.cluster_k8s_resource_group}"
  }

  depends_on = ["null_resource.kubernetes_cluster_definition"]
}

#Template post-deployment execution
data "template_file" "acs_engine_post_deployment" {
  template = "${file("../../templates/routing_tables.sh.tpl")}"

  vars {
    cluster_k8s_resource_group     = "${var.cluster_k8s_resource_group}"
    kubernetes_agents_subnet_name  = "${var.agents_subnet_name}"
    kubernetes_masters_subnet_name = "${var.masters_subnet_name}"
    vnet_name                      = "${var.vnet_name}"
    cluster_resource_group         = "${var.cluster_resource_group}"
    subscription_id                = "${var.subscription_id}"
  }

  depends_on = ["data.template_file.acs_engine"]
}

# Create Cluster Definition File
resource "null_resource" "kubernetes_cluster_definition_deployment" {
  provisioner "local-exec" {
    command = "cat > cluster_deployment.sh <<EOL\n${join(",\n", data.template_file.acs_engine.*.rendered)}\nEOL"
  }

  depends_on = ["null_resource.kubernetes_cluster_definition", "data.template_file.acs_engine"]
}

# Perform the deployment against Windows Azure
resource "null_resource" "run_acs_engine" {
  provisioner "local-exec" {
    command = "sh cluster_deployment.sh"
  }  

  depends_on = ["null_resource.kubernetes_cluster_definition_deployment"]
}

# Create Routing Tables Shell Script
resource "null_resource" "kubernetes_acs_engine_post_deployment_scripting" {
  provisioner "local-exec" {
    command = "cat > routing_tables.sh <<EOL\n${join(",\n", data.template_file.acs_engine_post_deployment.*.rendered)}\nEOL"
  }

  depends_on = ["null_resource.run_acs_engine"]
}

# Execute Routing Tables Shell Script
resource "null_resource" "run_acs_engine_post_deployment" {
  provisioner "local-exec" {
    command = "sh routing_tables.sh"
  }

  depends_on = ["null_resource.kubernetes_acs_engine_post_deployment_scripting"]
}
