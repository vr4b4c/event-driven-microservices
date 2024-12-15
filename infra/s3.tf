resource "aws_s3_bucket" "ordering_platform_api" {
  bucket        = "ordering-platform-api"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "ordering_platorm_api" {
  bucket                  = aws_s3_bucket.ordering_platform_api.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}
