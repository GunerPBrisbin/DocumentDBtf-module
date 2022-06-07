<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# {description}
DocumentDB Resource.
Best practices found here : https://docs.aws.amazon.com/documentdb/latest/developerguide/best_practices.html

## Usage
TODO: add usage

### Examples
TODO: add examples

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.export_docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_docdb_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_docdb_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group) | resource |
| [aws_docdb_cluster_snapshot.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_snapshot) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.apollo](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Name of the application | `string` | n/a | yes |
| <a name="input_apply_immediatley"></a> [apply\_immediatley](#input\_apply\_immediatley) | (Optional) Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. This also Applies to the Instances Default is false | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | (Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default true. | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) A list of EC2 Availability Zones that instances in the DB cluster can be created in. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | (Optional) The days to retain backups for. Default 1 | `number` | `null` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | (Optional) The cluster identifier. If omitted, Terraform will assign a random, unique identifier. | `string` | `null` | no |
| <a name="input_data_tags"></a> [data\_tags](#input\_data\_tags) | Data tags map, specifies the data specific tags to be attached to the RDS resouces. | `map(string)` | n/a | yes |
| <a name="input_db_cluster_snapshot_identifier"></a> [db\_cluster\_snapshot\_identifier](#input\_db\_cluster\_snapshot\_identifier) | (Optional) The Identifier for DocDB snapshot creation. | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | (Optional) A DB subnet group to associate with this DB instance, Will default to Database subnet group | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Optional) A value that indicates whether the DB cluster has deletion protection enabled. The database can't be deleted when deletion protection is enabled. By default, deletion protection is disabled. | `bool` | `false` | no |
| <a name="input_enable_cloud_watch_profiler_logs"></a> [enable\_cloud\_watch\_profiler\_logs](#input\_enable\_cloud\_watch\_profiler\_logs) | (Optional) Enables profiler logs in addition to audit logs. Defaults to false | `bool` | `false` | no |
| <a name="input_enable_tls"></a> [enable\_tls](#input\_enable\_tls) | Defines whether Transport Layer Security (TLS) connections are required. | `bool` | `true` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) The database engine version. Updating this argument results in an outage. | `number` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | dev, test, prod, stage, sandbox | `string` | `""` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made. | `string` | `null` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The identifier for the DocDB instance | `string` | `null` | no |
| <a name="input_initial_password"></a> [initial\_password](#input\_initial\_password) | (Required unless a snapshot\_identifier is provided) Initial password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. | `string` | n/a | yes |
| <a name="input_initial_username"></a> [initial\_username](#input\_initial\_username) | (Required unless a snapshot\_identifier is provided) Initial username for the master DB user. | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class for each instance in the cluster. The Following are acceptable: db.r5.large,  db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge, db.r5.12xlarge, db.r5.24xlarge, db.r4.large, db.r4.xlarge, db.r4.2xlarge, db.r4.4xlarge, db.r4.8xlarge, db.r4.2416xlarge, db.t3.medium | `string` | `"db.t3.medium"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number Of instances to be created, This will also be appended to the end of the Identifier | `number` | `1` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key | `string` | n/a | yes |
| <a name="input_log_retention_duration"></a> [log\_retention\_duration](#input\_log\_retention\_duration) | Defines the duration of time (in seconds) that the change stream log is retained and can be consumed. Valid Values: 3600-86400 | `string` | `"10800"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name (without the prefix/suffix) of each instance to be built. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | (Optional) The port on which the DB accepts connections | `number` | `27017` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | (Optional) The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter. Time in UTC. Default: A 30-minute window selected at random from an 8-hour block of time per regionE.g., 04:00-09:00 | `string` | `""` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | (Optional) The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30. This Will Also Apply to the Instances. | `string` | `""` | no |
| <a name="input_profiler_sampling_rate"></a> [profiler\_sampling\_rate](#input\_profiler\_sampling\_rate) | Defines the sampling rate for logged operations. Values 0.0-1.0 | `number` | `1` | no |
| <a name="input_profiler_threshold_ms"></a> [profiler\_threshold\_ms](#input\_profiler\_threshold\_ms) | Defines the threshold for profiler. VAlid Values: 50-2147483646 | `number` | `100` | no |
| <a name="input_role"></a> [role](#input\_role) | Application Role (Used primarily by Ansible, but is not the same as AnsibleRole which is for ec2 instances) | `any` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | (Optional) Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final\_snapshot\_identifier. Default is false. | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | (Optional) Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | TFE Workspace tags pass through to be passed into module resources. | `map(string)` | n/a | yes |
| <a name="input_ttl_monitor"></a> [ttl\_monitor](#input\_ttl\_monitor) | Defines whether Time to Live (TTL) monitoring is enabled for the cluster. | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | FRB specific AWS VPC name where resources will be built/managed | `any` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate with the Cluster | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Amazon Resource Name (ARN) of cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The DNS address of the DocDB instance |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The DocDB Cluster Identifier |
| <a name="output_cluster_members"></a> [cluster\_members](#output\_cluster\_members) | List of DocDB Instances that are a part of this cluster |
| <a name="output_cluster_resource_id"></a> [cluster\_resource\_id](#output\_cluster\_resource\_id) | The DocDB Cluster Resource ID |
| <a name="output_reader_endpoint"></a> [reader\_endpoint](#output\_reader\_endpoint) | A read-only endpoint for the DocDB cluster, automatically load-balanced across replicas |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->