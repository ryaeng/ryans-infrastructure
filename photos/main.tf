terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.16.0"
    }
  }
}

data "linode_object_storage_cluster" "primary" {
  id = var.cluster_name
}

resource "linode_object_storage_bucket" "england_photos" {
  cluster = data.linode_object_storage_cluster.primary.id
  label   = var.bucket_label
}

resource "linode_object_storage_key" "keys" {
  for_each = toset(var.key_names)
  label    = each.key

  bucket_access {
    bucket_name = linode_object_storage_bucket.england_photos.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }

  depends_on = [
    linode_object_storage_bucket.england_photos
  ]
}

output "keys" {
  description = "Access & secret keys used to access bucket."
  sensitive   = true
  value       = {
    for key in linode_object_storage_key.keys : key.label => { 
      access_key = key.access_key,
      secret_key = key.secret_key
    }
  }
}
