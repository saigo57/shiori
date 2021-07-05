terraform {
  required_version = "~> 1.0.0"
  backend "s3" {
    bucket  = "shiori-movie-terraform"
    region  = "ap-northeast-1"
    profile = "terraformer"
    key     = "terraform.tfstate"
    encrypt = false
  }
}
