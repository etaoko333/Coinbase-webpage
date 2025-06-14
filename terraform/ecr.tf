resource "aws_ecr_repository" "react-app" {
  name                 = "react-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}