resource "aws_ecs_cluster" "ecs_cluster" {
  name = "shiori-${terraform.workspace}-cluster"
}
