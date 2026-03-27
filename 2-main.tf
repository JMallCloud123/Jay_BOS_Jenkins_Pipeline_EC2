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
resource "aws_s3_object" "png" {
  bucket = aws_s3_bucket.frontend.id
  key    = "Armaggeddon_Evidence/Theo_Passed_Project.png"
  source = "${path.module}/Armaggeddon_Evidence/Theo_Passed_Project.png"
}  