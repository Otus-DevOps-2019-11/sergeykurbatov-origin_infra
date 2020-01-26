terraform {
  backend "gcs" {
    bucket = "storage-bucket-prod-inf"
    prefix = "terraform/state"
  }
}
