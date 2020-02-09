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

# Homework 07
1. Created modules configuration on terraform. Modules: `app`, `db`, `vpc`
2. Created packer image for db and app vm
3. Added Prod and stage build on terraform for more productivly work
4. Added storage bucket module configuration
5. Added on prod and stage build backend module for save terraform state file on early created storage bucket

For work connection to database in module `app` created variable `db_ip` contained `google_compute_instance.db.network_interface.0.network_ip`

For launch storage bucket command `terraform init terraform/`, `terraform plan terraform/` and `terraform apply terraform/`
For launch prod infra command  `terraform init terraform/prod/`, `terraform plan terraform/prod/` and `terraform apply terraform/prod/`
For launch stage infra command  `terraform init terraform/stage/`, `terraform plan terraform/stage/` and `terraform apply terraform/stage/`

!!! For all servers you need to specify in file `terraform.tfvars`

For connect to server puma enter `external_app_ip` and port `9292`

# Homework 08

After first apply `ansible-playbook clone.yml` git clone repo, we delete it and retry apply `ansible-playbook clone.yml`. State changed, because we delete git repo dir and cloned another one and this directory before clone did not exist

For test ansible inventory in json format use command `ansible all -i ansible/inventory.json -m ping`

Ansible work with all of 3 inventory - *.json, *, *.yml. For configuration default file in `ansible.cfg` enter `inventory = ./inventory.json` for json format, or `inventory = ./inventory.yml` for yml format and other.

For working with dynamic inventory created file `ansible/dynamic_inventory.sh`. Script requested  2 outputs from terraform:
```
app_ip=`cd ../terraform/stage && terraform output | grep app_external_ip | awk '{print $3}'`
db_ip=`cd ../terraform/stage && terraform output | grep db_external_ip | awk '{print $3}'`
```
For running dynamic inventory `chmod +x ansible/dynamic_inventory.sh`, after that `ansible all -m ping -i ansible/dynamic_inventory.sh` or `ansible all --list -i ansible/dynamic_inventory.sh`

# Homework 09

- Added single play ansible playbook - `ansible/reddit_app_one_play.yml`
- Added Multiple play ansible playbook in single file - `ansible/reddit_multiple_play.yml`
- Added moduleted ansible playbook:
  - `ansible/site.yml` - main playbook included db.yml, app.yml, deploy.yml
  - `ansible/db.yml` - mongodb provisioning
  - `ansible/app.yml` - puma service provisioning
  - `absible/deploy.yml` - install web site files
- Added more var in dynamyc inventory script - db_int_ip
For working with dynamic inventory modife file `ansible/dynamic_inventory.sh`. Script requested added 1 outputs from terraform:
```
db_ip_int=`cd ../terraform/stage && terraform output | grep db_ip | awk '{print $3}'`
```
For launch dynamic inventory script execute command `chmod +x ansible/dynamic_inventory.sh`, after launch command - `cd ansible && ansible-playbook site.yml`
In file `ansible/app.yml`, in section vars added:
```
  vars:
   db_host: "{{ db_ip_int }}"
```
- Upgraded packer image for work with ansible playbook. Now installation worked with ansible, image builded with ansible playbook provisioning

# Homework 10
For role run use command `ansible-galaxy init app`
For run role add in playbook:
```
roles:
- app
```
For run dynamic inventory and deploy some application or service use:
```
ansible-playbook -i environments/prod/dynamic_inventory.sh playbooks/site.yml
```

Added community role:
```
- src: jdauphant.nginx
version: v2.21.1
```
And added this role in environments/prod/requirements.yml or environments/stage/requirements.yml
Config:
```
nginx_sites:
    default:
        - listen 80
        - server_name "reddit"
        - location / { proxy_pass http://127.0.0.1:9292; }
```
Added ansible vault key in ansible.cfg, in section [default]- `vault_password_file = vault.key`
After that added configuration about users in ansible/playbooks/users.yml
Encrypted credentials added in ansible/environments/prod/credentials.yml or ansible/environments/stage/credentials.yml

Edited file `.travis.yml` for test configurations about terraform and ansible 

# Homework 11
Installed and created `vagrantfile` for local test servers and applications.
In  `vagrantfile` incerted ansible provision for autoinstall all dependencies. 
Updated ansible roles and packer playbook for db and app servers.
Instaled molecule for testing application.
Updated molecule config for auto test application connection.
DB ansible role add in `requirments.yml` for remote install.
