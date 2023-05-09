########################################  Local Variables ####################################
locals {
  tags = tomap({
    Environment = var.environment
    ProjectName = var.project_name
  })
}


locals {
  bucket-name = "${var.s3_bucket_name}-${var.environment}-${var.aws_region}"
}
########################################  Creating aa S3 Bucket ####################################
resource "aws_s3_bucket" "hyacinth_s3_bucket" {
  bucket        = local.bucket-name
  force_destroy = true

  tags = local.tags
}

######################################## SSE Encryption ############################################
resource "aws_s3_bucket_server_side_encryption_configuration" "hyacinth_s3_bucket_sse" {
  bucket = aws_s3_bucket.hyacinth_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key
      sse_algorithm     = "aws:kms"
    }
  }
}

######################################## S3 Lifecycle Policy To Delete Incomplete Upload ###########
resource "aws_s3_bucket_lifecycle_configuration" "hyacinth_s3_bucket_lifecycle_policy" {
  bucket = aws_s3_bucket.hyacinth_s3_bucket.id

  #   rule {
  #     id     = "Keep previous version 30 days, then in Glacier another 60"
  #     status = "Enabled"

  #     noncurrent_version_transition {
  #       noncurrent_days = 30
  #       storage_class   = "GLACIER"
  #     }

  #     noncurrent_version_expiration {
  #       noncurrent_days = 90
  #     }
  #   }

  rule {
    id     = "Delete old incomplete multi-part uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 3
    }
  }
}