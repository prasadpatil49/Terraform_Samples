## Remote State Management:

### *Requirements:*

1. Create a new S3 bucket for the remote state
   - bucket name: terraform-state-bucket
   - region: us-east-1
   - Directory: terraform_state

    ```
    aws --endpoint-url=http://localhost:4566 \
    s3 mb s3://terraform-state-bucket --region us-east-1
    ```
    ```
    aws --endpoint-url=http://localhost:4566 \
    s3api put-object --bucket terraform-state-bucket --key terraform_state/
    ```


### *Terraform Configuration:*

```
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "terraform_state/terraform.tfstate"
    region = "us-east-1"
    access_key = "test"
    secret_key = "test"

    endpoint  = "http://s3.localhost.localstack.cloud:4566"

    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    
  }
}
```