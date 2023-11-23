######################################
#  ec2/snapshot-lifecycle-policy.tf  #
######################################

resource "aws_dlm_lifecycle_policy" "snapshot_ec2" {
  count              = length(keys(var.snapshot_schedule_rule)) > 0 ? 1 : 0
  description        = "${replace((var.name), "-", " ")} lifecycle snapshot policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle.0.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    dynamic "schedule" {
      for_each = [var.snapshot_schedule_rule]
      content {
        name = schedule.value.name
        create_rule {
          interval      = tonumber(schedule.value.interval)
          interval_unit = schedule.value.interval_unit
          times         = [schedule.value.times]
        }
        retain_rule {
          count = tonumber(schedule.value.retain_days)
        }
        tags_to_add = {
          SnapshotCreator = "DLM"
        }
        copy_tags = true
      }
    }
    target_tags = aws_instance.ec2.tags
  }
}