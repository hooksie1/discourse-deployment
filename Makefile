.PHONY: clean plan apply inventory roles destroy

all: terraform plan apply inventory roles

plan: 
		cd $(env)/$(type) && \
		terraform init 
		cd $(env)/$(type) && \
		terraform plan -out plan

apply: plan
		cd $(env)/$(type) && \
		terraform apply -input=false plan

destroy: download
		cd $(env)/$(type) && \
		terraform init && \
		terraform destroy -auto-approve

inventory: apply
		cd $(env)/$(type) && \
		cp inventory ../../ansible/

roles:
		git clean -fdx ansible/roles/
		ansible-galaxy install -r ansible/roles/requirements.yml

clean:
		git clean -fd
		git clean -fx
		git reset --hard