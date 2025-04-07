
# IAM Policy for reading secrets from Secrets Manager
resource "aws_iam_policy" "secretsmanager_read_policy" {
  name        = "${local.env}-${local.eks_name}-secretsmanager-read"
  description = "Allow read access to AWS Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM Role for IRSA
resource "aws_iam_role" "secretsmanager_irsa_role" {
  name = "${local.eks_name}-irsa-secretsmanager-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa"
        }
      }
    }]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "secretsmanager_policy_attach" {
  role       = aws_iam_role.secretsmanager_irsa_role.name
  policy_arn = aws_iam_policy.secretsmanager_read_policy.arn
}
