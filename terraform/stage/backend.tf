terraform {
  backend "gcs" {
    bucket = "storage-bucket-stage-inf"
    prefix = "terraform/state"
  }
}