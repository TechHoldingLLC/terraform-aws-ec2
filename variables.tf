######################
#  ec2/variables.tf  #
######################

variable "ami_id" {
  description = "EC2 AMI id"
  type        = string
}

variable "disable_api_termination" {
  description = "Termination protection"
  type        = bool
  default     = true
}

variable "eip" {
  description = "Create elastic ip flag"
  type        = bool
  default     = false
}

variable "ebs_block_device" {
  description = "EBS block device volume"
  default     = []
}

variable "ebs_optimized" {
  description = "EBS optimization"
  type        = bool
  default     = null
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device/ebs_block_device tags)"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.nano"
}

variable "ipv6_address_count" {
  description = "IPv6 address count"
  type        = number
  default     = 0
}

variable "key_name" {
  description = "Instance key-pair name"
  type        = string
  default     = ""
}

variable "name" {
  description = "Instance name for tag"
  type        = string
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "subnet" {
  description = "EC2 subnet group"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Additional security groups or dont want to use default vpc security group and configure specific security group for instance"
  type        = list(any)
}

variable "snapshot_schedule_rule" {
  description = "Snapshot creation rule"
  type        = any
  default     = {}
}

variable "source_dest_check" {
  description = "Source destination check"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = {}
}

variable "user_data" {
  description = "EC2 user data or cloud init script"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = null
}