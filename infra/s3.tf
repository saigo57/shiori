resource "aws_s3_bucket" "backet" {
  bucket = "shiori-${terraform.workspace}-backet"
  acl    = "private"

  tags = {
    Name        = "shiori-${terraform.workspace}"
  }
}
