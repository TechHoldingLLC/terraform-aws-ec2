################
#  ec2/iam.tf  #
################

#--------------------------------------------------------------------------
# Resource for creation IAM role for EC2 instance
#--------------------------------------------------------------------------
resource "aws_iam_role" "dlm_lifecycle" {
  count              = length(keys(var.snapshot_schedule_rule)) > 0 ? 1 : 0
  name               = "${var.name}-dlm-lifecycle-snapshot-ec2"
  assume_role_policy = data.aws_iam_policy_document.dlm_lifecycle_trust_policy.json
}

data "aws_iam_policy_document" "dlm_lifecycle_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  count  = length(keys(var.snapshot_schedule_rule)) > 0 ? 1 : 0
  name   = aws_iam_role.dlm_lifecycle.0.id
  role   = aws_iam_role.dlm_lifecycle.0.id
  policy = data.aws_iam_policy_document.dlm_lifecycle_policy.json
}

data "aws_iam_policy_document" "dlm_lifecycle_policy" {
  statement {

    effect = "Allow"

    actions = [
      "ec2:CreateTags"
    ]

    resources = ["arn:aws:ec2:*::snapshot/*"]
  }
  statement {

    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }
}