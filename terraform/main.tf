
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~>3.1.1"
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


# Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
  
  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_storage_bucket" "private-equityl" {
  name          = "private-equity"
  location      = "US"
  force_destroy = true
    }

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "3.2.0"

  topic      = "priv-equity"
  project_id = "majestic-lodge-342902"

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
