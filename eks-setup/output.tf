output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "oidc_provider" {
  value = aws_iam_openid_connect_provider.eks.url
}

output "region" {
  description = "AWS region"
  value       = local.region
}