/*
 * # {description}
 * DocumentDB Resource. 
 * Best practices found here : https://docs.aws.amazon.com/documentdb/latest/developerguide/best_practices.html
 *
 * ## Usage
 * Use To create a Regional DocumentDB cluster. This will be encrypted by default and cannot be changed. 
 *
 * ### Examples
 * TODO: add examples
 (
 * ## Notes
 * There Will be no default KMS Key for this module. You will need to provide a KMS Key to create a DocumentDB cluster.
 * Update the username and password as these will be stored in the state file. 
 *
 */

locals {
  env                                = var.env != "" ? var.env : local.acct
  timestamp                          = timestamp()
  now                                = replace(local.timestamp, "/[- TZ:]/", "")
  name                               = coalesce(var.name, "${var.vpc_name}-${var.app}")

  vpc_name_prefix                    = data.terraform_remote_state.vpc.outputs.name
  availability_zones                 = coalescelist(var.availability_zones, ["${local.region}a", "${local.region}b", "${local.region}c"])
  db_subnet_group_name               = coalesce(var.db_subnet_group_name, data.terraform_remote_state.vpc.outputs.db_subnetgroup)

  port                               = coalesce(var.port, 27017)

  enabled_cloudwatch_logs_exports    = var.enable_cloud_watch_profiler_logs ? ["audit", "profiler"] : ["audit"]

  backup_retention_period            = var.preferred_backup_window != "" ? coalesce(var.backup_retention_period, 1) : null
  preferred_backup_window            = var.backup_retention_period != null ? coalece(var.preferred_backup_window, "0400-0900") : ""

  preferred_maintenance_window       = coalesce(var.preferred_maintenance_window, "wed:04:00-wed:04:30")

  use_cluster_identifier             = var.cluster_identifier == null ? false : true
  cluster_identifier_prefix          = var.cluster_identifier != null ? "${var.cluster_identifier}-" : "${local.name}-"
  cluster_identifier                 = var.cluster_identifier != null ? var.cluster_identifier : "${local.name}"

  skip_final_snapshot                = coalesce(var.skip_final_snapshot, false)
  final_snapshot_identifier          = var.skip_final_snapshot ? null : var.final_snapshot_identifier != null ? var.final_snapshot_identifier : "${local.name}-DocDB-final-snapshot-${local.now}"

  username = var.snapshot_identifier == null ? var.initial_username : null
  password = var.snapshot_identifier == null ? var.initial_password : null
}

resource "aws_docdb_cluster" "this" {
  apply_immediately               = var.apply_immediatley

  availability_zones              = local.availability_zones

  db_subnet_group_name            = local.db_subnet_group_name

  deletion_protection             = var.deletion_protection

  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name

  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports

  engine_version                  = var.engine_version

  kms_key_id                      = var.kms_key_id
  storage_encrypted               = true

  master_password                 = local.password
  master_username                 = local.username

  port                            = local.port

  preferred_backup_window         = local.preferred_backup_window
  backup_retention_period         = local.backup_retention_period
  
  final_snapshot_identifier       = local.final_snapshot_identifier
  skip_final_snapshot             = local.skip_final_snapshot

  preferred_maintenance_window    = local.preferred_maintenance_window

  vpc_security_group_ids          = var.vpc_security_group_ids

  cluster_identifier_prefix       = local.use_cluster_identifier ? null : local.cluster_identifier_prefix
  cluster_identifier              = local.use_cluster_identifier ? local.cluster_identifier : null

  global_cluster_identifier       = var.global_cluster_identifier
  provider                        = aws.cluster

  tags = merge({
    Name            = "${local.name}-docdb-cluster"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env
  }, var.tags, var.data_tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      cluster_identifier,
      cluster_identifier_prefix,
      db_subnet_group_name,
      master_username,
      master_password,
    ]
  }
}
locals {
  use_instance_identifier = var.identifier == null ? false : true
  identifier_prefix       = var.identifier != "" ? "${var.identifier}-" : "${local.name}-"
  identifier              = var.identifier != "" ? var.identifier : "${local.name}"

}

resource "aws_docdb_cluster_instance" "this" {
  count                        = var.instance_count

  apply_immediately            = var.apply_immediatley

  auto_minor_version_upgrade   = var.auto_minor_version_upgrade

  cluster_identifier           = aws_docdb_cluster.this.id



  identifier                   = local.use_instance_identifier ? "${local.identifier}-i-${count.index}" : null
  identifier_prefix            = local.use_instance_identifier ? null : "${local.identifier}-i-${count.index}-"

  instance_class               = var.instance_class

  preferred_maintenance_window = local.preferred_maintenance_window
  provider                     = aws.cluster

  tags = merge({
    Name            = "${local.name}-docdb-cluster-i"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env
  }, var.tags, var.data_tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      identifier,
      identifier_prefix
    ]
  }
}

locals {
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier != "" ? var.db_cluster_snapshot_identifier : "${local.name}-docdb-cluster-ss-${local.now}"

  take_snapshot                  = var.backup_retention_period != null ? true : false
}

resource "aws_docdb_cluster_snapshot" "this" {
  count                          = local.take_snapshot ? 1 : 0

  db_cluster_identifier          = aws_docdb_cluster.this.id

  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier
}

locals {
  docdb_cluster_parameters = [
    {
      name = "audit_logs"
      value = "enabled"
      apply_method = "immediate"
    },

    {
      name = "change_stream_log_retention_duration"
      value = var.log_retention_duration
      apply_method = "pending-reboot"
    },

    {
      name = "profiler"
      value = var.enable_cloud_watch_profiler_logs ? "enabled" : "disabled"
      apply_method = "immediate"
    },

    {
      name = "profiler_sampling_rate"
      value = var.profiler_sampling_rate
      apply_method = "pending-reboot"
    },

    {
      name = "profiler_threshold_ms"
      value = var.profiler_threshold_ms
      apply_method = "pending-reboot"
    },

    {
      name = "tls"
      value = var.enable_tls ? "enabled" : "disabled"
      apply_method = "immediate"
    },

    {
      name = "ttl_monitor"
      value = var.ttl_monitor ? "enabled" : "disabled"
      apply_method = "immediate"
    }
  ]
  family = var.engine_version == "4.0.0" ? "docdb4.0" : "docdb3.6"
}

resource "aws_docdb_cluster_parameter_group" "this" {
  family      = local.family
  name        = "${local.name}-docdb-pg-${var.region}"
  description = "docdb cluster parameter group"
  provider    = aws.cluster

   dynamic "parameter" {
    for_each = local.docdb_cluster_parameters
    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }


  tags = merge({
    Name            = "${local.name}-docdb-pg"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env
  }, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}
