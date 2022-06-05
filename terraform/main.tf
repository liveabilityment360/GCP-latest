module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.1.1"
}

variable "gcp_region" {
  type        = string
  description = "Region of FINFO project execution"
  default     = "Melbourne"
}

variable "gcp_zone" {
  type        = string
  description = "Project zone"
  default     = "australia-southeast2-a"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config"
}

variable "rolesList" {
type =list(string)
default = ["roles/iam.serviceAccountAdmin","roles/storage.admin"]
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}
resource "google_storage_bucket" "private-equity" {
  name          = "striped-impulse-352211"
  location      = "australia-southeast2"
  force_destroy = true
    }
resource "google_service_account" "service_account" {
  account_id   = "finfo-sa"
  display_name = "FINFO Service Account"
}

resource "google_project_iam_binding" "sa_account_iam" {
project = var.gcp_project
count = length(var.rolesList)
role =  var.rolesList[count.index]
members = [
  "serviceAccount:${google_service_account.service_account.email}"
]
depends_on = [google_service_account.service_account]
}
