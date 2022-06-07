resource "aws_cloudwatch_log_subscription_filter" "export_docdb" {
  
  name            = "docdb_cluster_export"
  role_arn        = data.terraform_remote_state.apollo.outputs.role
  log_group_name  = "/aws/docdb/${aws_docdb_cluster.this.id}/audit"
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.apollo.outputs.arn

  depends_on = [
    aws_docdb_cluster_instance.this[0]
  ]
}