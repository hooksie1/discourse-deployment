terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "JHB"

        workspaces {
            name = "discourse-services"
        }
    }
}

data "terraform_remote_state" "infrastructure" {
    backend = "remote"
    config = {
        organization = "JHB"
        workspaces = {
            name = "discourse-infrastructure"
        }
    }
}

module "instances" {
    source                  = "github.com/hooksie1/discourse-aws//instances?ref=v1.1"
    region                  = "us-east-1"
    domain_name             = "cloudprepared.com"
    ec2_instance_type       = "t2.micro"
    max_instance_size       = "15"
    min_instance_size       = "3"
    default_ami             = "ami-07d0cf3af28718ef8"
    wazuh_ec2_instance_type = "t2.micro"
    vpn_subnet_cidr         = "10.1.1.0/24"
    web_subnet_cidr         = data.terraform_remote_state.infrastructure.outputs.CP_web_subnet_cidr
    db_subnet_cidr          = "10.1.4.0/24"
    app_subnet_cidr         = "10.1.5.0/24"
    mgmt_subnet_cidr        = data.terraform_remote_state.infrastructure.outputs.CP_mgmt_subnet_cidr
    home_ip                 = ""
    vpn_ip                  = ""
    work_ip                 = ""
    key_pair_name           = "cloudprepared"
    dns_zone                = ""
    web_sec_group_id        = data.terraform_remote_state.infrastructure.outputs.CP_web_sg_id
    ssh_sec_group_id        = data.terraform_remote_state.infrastructure.outputs.CP_ssh_sg_id
}

