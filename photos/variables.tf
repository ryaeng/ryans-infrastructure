variable "cluster_name" {
  description = "Name of the cluster on which buckets will be created. (required)"
  default     = "us-iad-1"
}

variable "bucket_label" {
  description = "Name of the bucket being created. (required)"
}

variable "key_names" {
  description = "List of key names that will be created. (required)"
}
