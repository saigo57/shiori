variable alb_config {}

terraform {
  required_version = ">= 0.11.7"
  backend "s3" {
    bucket  = "shiori-terraform"
    region  = "ap-northeast-1"
    profile = "terraformer"
    key     = "terraform.tfstate"
    encrypt = false
  }
}
