terraform {
  backend "gcs" {
    bucket = "storage-bucket-prod"
    prefix = "terraform/state"
  }
}
