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