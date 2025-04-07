resource "aws_security_group" "eks_cluster_sg" {
  name        = "${local.eks_name}-cluster-sg-${local.env}"
  description = "EKS Cluster communication with worker nodes"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow worker nodes to communicate with EKS Control Plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Modify for more restrictive access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.eks_name}-cluster-sg-${local.env}"
  }
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "${local.eks_name}-nodes-sg-${local.env}"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    self            = true
    description     = "Allow node-to-node communication"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow kubelet/metrics-server/API
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.eks_name}-nodes-sg-${local.env}"
  }
}
