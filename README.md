# terraform instructons for deploying Ubuntu 18 on AWS

## First step


Create file with AWS credentials like^
    variable "access_key" {
      description = "AWS access key"
      default     = "YOUR_ACCESS_KEY"
    }

    variable "secret_key" {
      description = "AWS secret key"
      default     = "YOUR_SECRET_KEY"
    }


## Run

    terraform plan
    terraform check

This code will do:
  - deploy ubuntu18
  - install kubuntu-desktop
  - copy settings file for XRDP

After what you should add user account and set password:

    useradd -m user-01
    passwd user-01
