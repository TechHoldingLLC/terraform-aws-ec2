# EC2
Below is an examples of calling this module.

## EC2 instance with minimal instance type and default VPC subnets and security group
```
module "ec2" {
  source = "./ec2"
  name    = "my-project-server"
  ami_id  = "ami-079b5e5b3971"
  security_group_ids    = ["sg-4d8e0130"]
}
```

## EC2 instance with custom network, volume, snapshot schedule and other configuration options
```
module "ec2" {
  source = "./ec2"
  name          = "my-project-server"
  ami_id        = "ami-079b5e5b3971b"
  instance_type = "t3.small"
  key_name      = "my-project-key"

  enable_volume_tags = false
  ## Launch script
  user_data     = <<END
  #!/bin/bash
  set -e -x
  echo "---- Running Launch Script ----"
  END

  ## Volume
  root_block_device = [
    {
      volume_size           = 10
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
    }
  ]

  ## EBS volume
  ebs_block_device = [
    {
      device_name           = "xvdf"
      volume_size           = 500
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      tags = {
        Name = "Data"
      }
    }
  ]

  ## Network
  subnet                = "subnet-c95032"
  vpc_id                = "vpc-b0a8db"
  eip                   = true

  ### Additional security groups or dont want to use default vpc security group and configure specific security group for instance
  security_group_ids    = ["sg-4d8e0130"]

  ### Configure schedule snapshot of instance volumes. Note: Rule matches the instance tags to target
  snapshot_schedule_rule = {
    name          = "Daily snapshot for a week"
    interval      = 24
    interval_unit = "HOURS"
    times         = ["00:00"]
    retain_days   = 7
  }
```