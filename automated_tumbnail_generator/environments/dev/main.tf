module "s3_bucket_images" {
  source = "../../modules/s3_bucket_images"
  bucket_name = "dev-thumbnail"
  environment = "dev"
}

module "lamdba_function" {
  source = "../../modules/lamdba_function"
  function_name = "dev-thumbnail-generator"
  environment = "dev"
  code_path = "../../python-code/"
  archive_path = "../../python-code/python_lambda.zip"
}