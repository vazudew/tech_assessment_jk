.PHONY: awsid
awsid:
	set -ex \
	&& aws sts get-caller-identity 

.PHONY: tf-init
tf-init:
	set -ex \
	&& terraform init


.PHONY: tf-plan
tf-plan:
	set -ex \
	&& terraform plan -out tf.plan

.PHONY: tf-apply
tf-apply: 
	set -ex \
	&& terraform apply --auto-approve  tf.plan

.PHONY: tf-destroy
tf-destroy:
	set -ex \
	&& terraform destroy --auto-approve