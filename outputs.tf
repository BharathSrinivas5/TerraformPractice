output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, "")
}