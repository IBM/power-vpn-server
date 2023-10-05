variable "content" {
  description = "plaintext data"
  type        = string
  sensitive   = true
}

variable "key" {
  description = "Key name for COS object"
  type        = string
}

variable "instance_name" {
  description = "COS instance name"
  type        = string
}

variable "bucket_name" {
  description = "Name of bucket to create key in"
  type        = string
}

variable "bucket_region" {
  description = "Region bucket will be created in"
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID for COS service instance"
  type        = string
}
