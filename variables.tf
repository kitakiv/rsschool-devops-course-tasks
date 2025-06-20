variable "test_bucket_name" {
  type        = string
  default     = "my-tf-test-bucket"
  description = "The name of the bucket to create"
}

variable "s3_bucket_tag" {
  type        = string
  default     = "My bucket"
  description = "The tag of the bucket to create"
}

variable "environment" {
  type        = string
  default     = "Dev"
  description = "The tag of the bucket to create"
}