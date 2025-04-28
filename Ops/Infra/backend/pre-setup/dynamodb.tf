module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  name     = "datnguyen-state-lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}