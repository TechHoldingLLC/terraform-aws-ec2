####################
#  ec2/outputs.tf  #
####################

output "public_ip" {
  value = var.eip ? aws_eip.eip[0].public_ip : aws_instance.ec2.public_ip
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "network_interface_id" {
  value = aws_instance.ec2.primary_network_interface_id
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

################################################################################
# IAM Role / Instance Profile
################################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = try(aws_iam_role.ec2_instance[0].name, null)
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = try(aws_iam_role.ec2_instance[0].arn, null)
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(aws_iam_role.ec2_instance[0].unique_id, null)
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = try(aws_iam_instance_profile.ec2_instance[0].arn, null)
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(aws_iam_instance_profile.ec2_instance[0].id, null)
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = try(aws_iam_instance_profile.ec2_instance[0].unique_id, null)
}
