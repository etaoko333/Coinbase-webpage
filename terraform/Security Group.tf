resource "aws_security_group" "react.sg" {
  name        = "dev-sg"
  description = "Enable HTTP/HTTPS access on port 80/443 and SSH access on port 22"
  vpc_id      = aws_vpc.vpc.id

  # Ingress traffic (Inbound)
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Ingress traffic (Inbound)
  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress traffic (Outbound)
  egress {
    from_port   = 0 # Allows all outbound traffic
    to_port     = 0
    protocol    = "-1" # Use "-1" for all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "react-sg" # Provide a meaningful name for the security group
  }
}