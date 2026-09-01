terraform{
    backend "s3" {
        bucket="terraform-state-file-surya"
        key="dev/terraform.tfstate"
        region = "ap-south-2"
        use_lockfile = true
        encrypt = true
        }
}