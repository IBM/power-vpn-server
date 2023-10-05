output "data" {
  value       = local.ovpn_data
  description = "OVPN file content"
  sensitive   = true
}
