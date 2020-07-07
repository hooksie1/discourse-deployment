terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "JHB"

        workspaces {
            name = "discourse-infrastructure"
        }
    }
}

module "discourse" {
    source              = "github.com/hooksie1/discourse-aws//infrastructure"
    region              = "us-east-1"
    CP_vpc_cidr         = "10.1.0.0/16"
    CP_web_subnet_cidr  = "10.1.2.0/24"
    CP_mgmt_subnet_cidr = "10.1.6.0/24"
    home_ip             = ""
    vpn_ip              = ""
    work_ip             = ""

}