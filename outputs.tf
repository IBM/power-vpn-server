##############################################################################
# Terraform Outputs
##############################################################################

output "bucket_url" {
  value       = local.bucket_url
  description = "URL to bucket containing the OVPN file"
}
