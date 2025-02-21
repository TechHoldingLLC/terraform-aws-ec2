################
#  ec2/ec2.tf  #
################

#--------------------------------------------------------------------------
# resource for creating ec2 instance 
#--------------------------------------------------------------------------
resource "aws_instance" "ec2" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  vpc_security_group_ids  = var.security_group_ids
  subnet_id               = var.subnet
  key_name                = length(var.key_name) > 0 ? var.key_name : var.name
  user_data               = var.user_data
  disable_api_termination = var.disable_api_termination
  source_dest_check       = var.source_dest_check
  ebs_optimized           = var.ebs_optimized
  volume_tags             = var.enable_volume_tags ? { "Name" = var.name } : null
  ipv6_address_count      = var.enable_ipv6 ? var.ipv6_address_count : 0
  iam_instance_profile    = var.create_iam_instance_profile ? aws_iam_instance_profile.ec2_instance[0].name : var.iam_instance_profile

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      volume_size           = lookup(root_block_device.value, "volume_size", 8)
      volume_type           = lookup(root_block_device.value, "volume_type", "standard")
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", true)
      encrypted             = lookup(root_block_device.value, "encrypted", true)
      tags                  = try(root_block_device.value.tags, null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, true)
      iops                  = try(ebs_block_device.value.iops, null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }

  lifecycle {
    ignore_changes = [ami]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    {
      Name = var.name
    }, var.tags
  )
}

#--------------------------------------------------------------------------
# resource for allocation elastic ip to ec2 instnace
#--------------------------------------------------------------------------
resource "aws_eip" "eip" {
  count    = var.eip ? 1 : 0
  instance = aws_instance.ec2.id
  domain   = "vpc"
  tags = {
    Name = var.name
  }
}