output "master_instance_id" {
  description = "EC2 instance ID of the Kubernetes master node"
  value       = aws_instance.master.id
}

output "master_ssm_status" {
  description = "SSM HTTP token status for master node (should be 'required')"
  value       = aws_instance.master.metadata_options[0].http_tokens
}

output "master_tags" {
  description = "Tags applied to the master node"
  value       = aws_instance.master.tags
}

output "worker_instance_ids" {
  description = "EC2 instance IDs of the Kubernetes worker nodes"
  value       = [for i in aws_instance.worker : i.id]
}

output "worker_ssm_statuses" {
  description = "SSM HTTP token status for worker nodes"
  value       = [for i in aws_instance.worker : i.metadata_options[0].http_tokens]
}

output "worker_tags_list" {
  description = "Tags applied to each worker node"
  value       = [for i in aws_instance.worker : i.tags]
}
