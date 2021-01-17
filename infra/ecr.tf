resource "aws_ecr_repository" "web" {
  name                 = "shiori-${terraform.workspace}/web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "shiori-${terraform.workspace}/app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
