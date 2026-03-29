resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true


  tags = {
    Name = "Jenkins Bucket"
  }
}
resource "aws_s3_object" "txt" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Armaggeddon_Evidence/BoS_Armageddon_Project_Class7_GitHub.txt"
  source = "${path.module}/Armaggeddon_Evidence/BoS_Armageddon_Project_Class7_GitHub.txt"
}
resource "aws_s3_object" "png1" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Armaggeddon_Evidence/Theo_Passed_Project.png"
  source = "${path.module}/Armaggeddon_Evidence/Theo_Passed_Project.png"
}

resource "aws_s3_object" "png2" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/JenkinsSuccessProof.png"
  source = "${path.module}/Jenkins_Server_Proof/JenkinsSuccessProof.png"
}

resource "aws_s3_object" "png3" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/JenkinsWebhookProof.png"
  source = "${path.module}/Jenkins_Server_Proof/JenkinsWebhookProof.png"
}

resource "aws_s3_object" "png4" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/JenkinsWebhookSuccessAfterGitPush1.png"
  source = "${path.module}/Jenkins_Server_Proof/JenkinsWebhookSuccessAfterGitPush1.png"
}

resource "aws_s3_object" "png5" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/S3Proof1.png"
  source = "${path.module}/Jenkins_Server_Proof/S3Proof1.png"
}

resource "aws_s3_object" "png6" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/S3Proof2.png"
  source = "${path.module}/Jenkins_Server_Proof/S3Proof2.png"
}

resource "aws_s3_object" "png7" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Jenkins_Server_Proof/S3PublicProof.png"
  source = "${path.module}/Jenkins_Server_Proof/S3PublicProof.png"
}
resource "aws_s3_bucket_public_access_block" "pab_name" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "bp_name" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.pab_name]
}