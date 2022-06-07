
output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_docdb_cluster.this.arn
}
output "cluster_members" {
  description = "List of DocDB Instances that are a part of this cluster"
  value       = aws_docdb_cluster.this.cluster_members
}
output "cluster_resource_id" {
  description = "The DocDB Cluster Resource ID"
  value       = aws_docdb_cluster.this.cluster_resource_id
}
output "cluster_endpoint" {
  description = "The DNS address of the DocDB instance"
  value       = aws_docdb_cluster.this.endpoint
}
output "cluster_id" {
  description = "The DocDB Cluster Identifier"
  value       = aws_docdb_cluster.this.id
}
output "reader_endpoint" {
  description = "A read-only endpoint for the DocDB cluster, automatically load-balanced across replicas"
  value       = aws_docdb_cluster.this.reader_endpoint
}