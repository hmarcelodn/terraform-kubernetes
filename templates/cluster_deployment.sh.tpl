#!/bin/sh
acs-engine deploy --subscription-id ${subscription_id} --dns-prefix ${dns_prefix} --location ${location_name} --auto-suffix --api-model kubernetes.json --resource-group ${cluster_resource_group}
