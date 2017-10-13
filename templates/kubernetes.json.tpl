{
  "apiVersion": "vlabs",
  "properties": {
    "orchestratorProfile": {
      "orchestratorType": "Kubernetes"
    },
    "masterProfile": {
      "count": 1,
      "dnsPrefix": "",
      "vmSize": "Standard_D2_v2",
      "vnetSubnetId": "${master_subnet_id}",
      "firstConsecutiveStaticIP": "${master_first_consecutive_static_ip}"     
    },
    "agentPoolProfiles": [
      {
        "name": "agentpool1",
        "count": ${agent_pool_count},
        "vmSize": "Standard_D2_v2",
        "availabilityProfile": "AvailabilitySet",
        "vnetSubnetId": "${nodes_subnet_id}"             
      }
    ],
    "linuxProfile": {
      "adminUsername": "azureuser",
      "ssh": {
        "publicKeys": [
          {
            "keyData": ""
          }
        ]
      }
    },
    "servicePrincipalProfile": {
      "servicePrincipalClientID": "",
      "servicePrincipalClientSecret": ""
    }
  }
}
