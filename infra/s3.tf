resource "aws_s3_bucket" "backet" {
  bucket = "shiori-movie-${terraform.workspace}-backet"
  acl    = "private"

  tags = {
    Name = "shiori-movie-${terraform.workspace}"
  }
}
