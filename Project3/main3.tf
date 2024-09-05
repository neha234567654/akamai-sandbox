terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.4.0"
    }
  }
}
//Use the Linode Provider
provider "linode" {
  token = var.token
}

//Use the linode_lke_cluster resource to create
//a Kubernetes cluster
resource "linode_lke_cluster" "miami-controller" {
    k8s_version = "1.30"
    label = "miami-controller"
    region = "us-mia"
    tags = ["testing"]

    pool {
        type  = "g6-standard-2"
        count = 3
    }
}

resource "linode_lke_cluster" "miami-worker" {
    k8s_version = "1.30"
    label = "miami-worker"
    region = "us-mia"
    tags = ["testing"]

    dynamic "pool" {
        for_each = var.pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
    }

  resource "linode_lke_cluster" "sao-paulo-worker" {
    k8s_version = "1.30"
    label = "sao-paulo-worker"
    region = "br-gru"
    tags = ["testing"]

    dynamic "pool" {
        for_each = var.pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
    }
    



//Export this cluster's attributes
output "miami-controller-kubeconfig" {
  value = linode_lke_cluster.miami-controller.kubeconfig
  sensitive = true
}

output "miami-worker-kubeconfig" {
  value = linode_lke_cluster.miami-worker.kubeconfig
  sensitive = true
}

output "sao-paulo-worker-kubeconfig" {
  value = linode_lke_cluster.sao-paulo-worker.kubeconfig
  sensitive = true
}


