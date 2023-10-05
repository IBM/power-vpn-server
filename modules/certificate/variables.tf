variable "name" {
  type        = string
  description = "Name for imported Secret Manager certificate."
}

variable "secret_manager_name" {
  type        = string
  description = "Name of the secret manager to import the server certificate."
}

variable "resource_group_id" {
  description = "Resource group the secret manager is in."
  type        = string
}
