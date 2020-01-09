# sergeykurbatov-origin_infra
sergeykurbatov-origin Infra repository

# Connecting to GCP internal host via ssh gateway

ssh -i ~/.ssh/appuser -A appuser@<external_ip_ssh_gw> -t ssh <internal_ip_host>

# Connecting to GCP internal host with alias via ssh gateway

1. Create ssh config file in localuser directory on bastion host (ssh gateway):
`touch ~/.ssh/config`
2. Change priv level on this file:
`chmod 600 ~/.ssh/config`
3. Modify file '~/.ssh/config' and incert this configuration:
```
Host someinternalhost
	HostName <internal_ip_host_of_internal_vm_on_gcp>
	User appuser
	Port 22
```
4. Now you can connect via `ssh someinternalhost`

# Connecting via VPN (openvpn)

bastion_IP = 34.76.5.117
someinternalhost_IP = 10.132.0.8
username = test
password/pin = in homework guide
vpn file = cloud-bastion.opvn

web page PRItunl:
login = pritunl
password = pritunl

Attantion!!! Web server on PRItunl worked on self signed certs, because Let's encrypt don't allow more 50 approved records in domains xip.io and sslip.io

# Created VM credential
testapp_IP = 34.76.5.117
testapp_port = 9292

# Creating VM on GCP with startup script (installing all feature and app Puma) 

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=https://github.com/Otus-DevOps-2019-11/sergeykurbatov-origin_infra/blob/cloud-testapp/startup-script.sh

# Creating network rule default-puma-server
gcloud compute firewall-rules create default-puma-server\
  --allow=tcp:9292 \
  --target-tags=puma-server 

# Homework 05
1. Created ubuntu 16.04 base image template for packer with variables and application for start Puma server
2. Created immutable image on ubuntu 16.04 with all application and puma server for start with 1 command
3. Created script for fast start puma server on GCP with image family reddit-full

# Homework 06
1. Created virtual machine based on image family reddit-base via terraform template.
2. Added on terraform template more users for ssh connection, firewall rule, installation and run all app puma server
3. Added web user ssh key

!!! For running terraform templaye you need to enter path for *.json file with credentials on GCP !!!

For load balansing you need to download and install module `gce-lb-http`. TCP port for all servers you need to specify in file `terraform.tfvars`, for example read file `terraform.tfvars.example`.

For launch infrastructure specify all parameters in file `terraform.tfvars`. 
After that command `terraform plan` and `terraform apply`.
