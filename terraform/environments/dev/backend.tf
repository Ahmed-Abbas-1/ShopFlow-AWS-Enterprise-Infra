terraform {
  backend "s3" {
    bucket       = "shopflow-tf-state-ahmedabbas992" 
    key          = "dev/infrastructure/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true 
  }
}
