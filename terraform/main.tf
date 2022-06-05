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


  
  # Create a single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "finfo-instance"
  machine_type = "e2-medium"
  zone         =  var.gcp_zone
  tags         = ["ssh"]

  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20220406"
    }
  }

# Install setup files
  #metadata_startup_script = "sudo apt-get update;sudo apt-get install git-core;sudo apt-get install apache2 php7.0;sudo apt install python3-pip;sudo pip install google-cloud;sudo pip install google-cloud-pubsub;python3 -m pip install --upgrade pip;pip install apache-beam;pip install apitools;pip install api-base;pip install --upgrade google-cloud-storage"
  metadata_startup_script = file("install.sh")
  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_storage_bucket" "private-equity" {
  name          = "striped-impulse-352211"
  location      = "australia-southeast2"
  force_destroy = true
    }

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "3.2.0"

  topic      = "priv_equi_topic"
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
