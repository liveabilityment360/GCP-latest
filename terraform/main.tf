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

# Use `gcloud` to enable:
# compute engine, pub/sub, dataflow, cloud build, cloud scheduler, cloud resource manager.

resource "null_resource" "enable_service_usage_api" {
  provisioner "local-exec" {
    command = "gcloud services enable pubsub.googleapis.com cloudbuild.googleapis.com cloudscheduler.googleapis.com cloudresourcemanager.googleapis.com --project ${var.gcp_project}"
  }  
}
  

resource "google_storage_bucket" "private-equity" {
  name          = var.gcp_project
  location      = "australia-southeast2"
  force_destroy = true
    }

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "3.2.0"

  topic      = "priv-equity1"
  project_id = var.gcp_project

pull_subscriptions = [
    {
      name                    = "pull"                                               // required
      ack_deadline_seconds    = 20                                                   // optional
      
      max_delivery_attempts   = 5                                                    // optional
      maximum_backoff         = "600s"                                               // optional
      minimum_backoff         = "300s"                                               // optional
     
      enable_message_ordering = true                                                 // optional
     
    }
  ]
depends_on = [null_resource.enable_service_usage_api]
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
