variable "vpc_name" {
  description = "FRB specific AWS VPC name where resources will be built/managed"
}

variable "name" {
  description = "The name (without the prefix/suffix) of each instance to be built."
  type        = string

  validation {
    condition     = !can(regex("[[:upper:]]", join(",", keys(var.name))))
    error_message = "The services map keys cannot contains uppercase or underscore characters, nor can they begin with svc-."
  }
}
variable "region" {
  description = "AWS region for cluster deployment"
  type        = string
  default     = "us-west-2"
}
variable "app" {
  description = "Name of the application"
  type        = string
}

variable "role" {
  description = "Application Role (Used primarily by Ansible, but is not the same as AnsibleRole which is for ec2 instances)"
}

variable "env" {
  description = "dev, test, prod, stage, sandbox"
  default     = ""
}

variable "tags" {
  description = "TFE Workspace tags pass through to be passed into module resources."
  type        = map(string)
#  default     = { BuiltBy = "terraform" }
}

variable "data_tags" {
  description = "Data tags map, specifies the data specific tags to be attached to the RDS resouces."
  type        = map(string)
  #  default = {
  #    ContainsPCI = "N"
  #    ContainsPII = "N"
  #  }
      validation {
    condition = can(regex("ContainsPCI", join(",", keys(var.data_tags))))
    error_message = "The tags map variable keys must contain the ContainsPCI tag."
    }

    validation {
    condition = can(regex("ContainsPII", join(",", keys(var.data_tags))))
    error_message = "The tags map variable keys must contain the ContainsPII tag."
    }
}
#DocDB Cluster Variables Start
#----------------------------------------------------------------------------------------#
variable "apply_immediatley" {
  description = "(Optional) Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. This also Applies to the Instances Default is false"
  type        = bool
  default     = false
}
variable "availability_zones" {
  description = " (Optional) A list of EC2 Availability Zones that instances in the DB cluster can be created in."
  type        = list(string)
  default     = [""]
}
variable "backup_retention_period" {
  description = "(Optional) The days to retain backups for. Default 1"
  type        = number
  default     = null
}
variable "cluster_identifier" {
  description = "(Optional) The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null
}
variable "db_subnet_group_name" {
  description = "(Optional) A DB subnet group to associate with this DB instance, Will default to Database subnet group"
  type        = string
  default     = ""
}
variable "deletion_protection" {
  description = "(Optional) A value that indicates whether the DB cluster has deletion protection enabled. The database can't be deleted when deletion protection is enabled. By default, deletion protection is disabled."
  type        = bool
  default     = false
}
variable "enable_cloud_watch_profiler_logs" {
  description = "(Optional) Enables profiler logs in addition to audit logs. Defaults to false"
  type        = bool
  default     = false
}
variable "engine_version" {
  description = "(Optional) The database engine version. Updating this argument results in an outage."
  type        = string
  default     = null
}
variable "final_snapshot_identifier" {
  description = "(Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made."
  type        = string
  default     = null
}
variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
}
variable "initial_password" {
  description = "(Required unless a snapshot_identifier is provided) Initial password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  type        = string
  sensitive   = true
}
variable "initial_username" {
  description = "(Required unless a snapshot_identifier is provided) Initial username for the master DB user."
  type        = string

  validation {
    condition     = var.initial_username != "admin"
    error_message = "Cannot use the username: admin."
  }
}
variable "port" {
  description = "(Optional) The port on which the DB accepts connections"
  type        = number
  default     = 27017
}
variable "preferred_backup_window" {
  description = "(Optional) The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter. Time in UTC. Default: A 30-minute window selected at random from an 8-hour block of time per region E.g., 04:00-09:00"
  type        = string
  default     = ""
}
variable "preferred_maintenance_window" {
  description = "(Optional) The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30. This Will Also Apply to the Instances."
  type        = string
  default     = ""
}
variable "skip_final_snapshot" {
  description = "(Optional) Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final_snapshot_identifier. Default is false."
  type        = bool
  default     = false
}
variable "snapshot_identifier" {
  description = "(Optional) Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
  type        = string
  default     = null
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
#  default     = [ "" ]
}
#----------------------------------------------------------------------------------------#
#DocDB Cluster Variables End


#DocDB Instance Variables Start
#----------------------------------------------------------------------------------------#
variable "auto_minor_version_upgrade" {
  description = "(Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default true."
  type        = bool
  default     = true
}
variable "identifier" {
  description = "The identifier for the DocDB instance"
  type        = string
  default     = null
}
# possible options are as follows for the instance type
# db.r5.large
# db.r5.xlarge
# db.r5.2xlarge
# db.r5.4xlarge
# db.r5.12xlarge
# db.r5.24xlarge
# db.r4.large
# db.r4.xlarge
# db.r4.2xlarge
# db.r4.4xlarge
# db.r4.8xlarge
# db.r4.16xlarge
# db.t3.medium
variable "instance_class" {
  description = "Instance class for each instance in the cluster. The Following are acceptable: db.r5.large,  db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge, db.r5.12xlarge, db.r5.24xlarge, db.r4.large, db.r4.xlarge, db.r4.2xlarge, db.r4.4xlarge, db.r4.8xlarge, db.r4.2416xlarge, db.t3.medium"
  type        = string
  default     = "db.t3.medium"
  validation {
    condition     = can(regex("db.t3.medium|db.r4.16xlarge|db.r4.8xlarge|db.r4.4xlarge|db.r4.2xlarge|db.r4.xlarge|db.r4.large|db.r5.24xlarge|db.r5.12xlarge|db.r5.4xlarge|db.r5.2xlarge|db.r5.xlarge|db.r5.large", var.instance_class))
    error_message = "Please enter one of the valid instance classes."
  }
}
variable "instance_count" {
  description = "Number Of instances to be created, This will also be appended to the end of the Identifier"
  type        = number
  default     = 1
}
#----------------------------------------------------------------------------------------#
# DocDB Instance Variables End

#DocDB Cluster Snapshot Variable
#----------------------------------------------------------------------------------------#
variable "db_cluster_snapshot_identifier" {
  description = "(Optional) The Identifier for DocDB snapshot creation."
  type        = string
  default     = ""
}
#----------------------------------------------------------------------------------------#

#DocDB Parameter Group Variables Start
#----------------------------------------------------------------------------------------#
variable "log_retention_duration" {
  description = "Defines the duration of time (in seconds) that the change stream log is retained and can be consumed. Valid Values: 3600-86400"
  type        = string
  default     = "10800"
}
variable "profiler_sampling_rate" {
  description = "Defines the sampling rate for logged operations. Values 0.0-1.0"
  type        = number
  default     = 1.0
}
variable "profiler_threshold_ms" {
  description = "Defines the threshold for profiler. VAlid Values: 50-2147483646"
  type        = number
  default     = 100
}
variable "enable_tls" {
  description = "Defines whether Transport Layer Security (TLS) connections are required."
  type        = bool
  default     = true
}
variable "ttl_monitor" {
  description = "Defines whether Time to Live (TTL) monitoring is enabled for the cluster."
  type        = bool
  default     = true
}
#----------------------------------------------------------------------------------------#
#DocDB Parameter Group Variables End

#DocDB Global Cluster Variables
#----------------------------------------------------------------------------------------#
variable "global_cluster_identifier" {
  description = "Global Cluster Identity, DO NOT GIVE A VALUE. This is passed in from the global Module"
  type        = string
  default     = null
}
