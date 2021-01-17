variable alb_config {}
variable database_name {}
variable db_username {}
variable db_password {}
variable rds_instance_class {}

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
