## Requirements
* gcloud CLI
* A GCP project that you have owner rights to
* Terraform
* jq as a helper

## Prereqs
* Generate SSH key:
```
ssh-keygen -f ./sshkey -b 2048 -t rsa -q -N "" -C "<user to use on the VM>"
```
* Copy public key to clipboard, to paste in .env file on next step
```
cat sshkey.pub
```
* Create .env file:
```
#!/bin/bash
export TF_VAR_GCP_PROJECT=<your project>
export TF_VAR_SSH_USER=<the user to use on the VM>
export TF_VAR_SSH_PUBKEY=<the output from the sshkey.pub file>
export TF_VAR_VPC_NAME=<desired vpc name>
export ACCT_NAME=<desired acct name>
export ACCT_DESC=<description of account>
```
* Source that file: `source .env`

* Login & set project:
```
gcloud auth login
gcloud config set project $TF_VAR_GCP_PROJECT
```
* Create Service Account:
```
gcloud iam service-accounts create $ACCT_NAME --display-name=$ACCT_NAME --description=$ACCT_DESC
```
* Add owner role to Service Account:
```
gcloud projects add-iam-policy-binding $TF_VAR_GCP_PROJECT --member="serviceAccount:$ACCT_NAME@$TF_VAR_GCP_PROJECT.iam.gserviceaccount.com" --role="roles/owner"
```
* Generate keys for Service Account:
```
gcloud iam service-accounts keys create key-file  --iam-account=$ACCT_NAME@$TF_VAR_GCP_PROJECT.iam.gserviceaccount.com
```
Note: You now have a `key-file` that has your service account private key. DO NOT COMMIT this into a repo.

## Terraform
* Workspace config: `terraform workspace new development`
* Switch to workspace: `terraform workspace select development`
* Init Terraform: `terraform init`
* Validate: `terraform validate`
* Plan: `terraform plan`
* Apply: `terraform apply --auto-approve`
Take note of the IP address, then copy that and open it up in your Browser: `http://<ip>:5000`. After a while, you'll see the Flask page populate.
* Test SSH:
```
ssh $TF_VAR_SSH_USER@$(terraform output -json | jq -r '.ip.value') -i sshkey
```
## Removal
* Destroy: `terraform destroy`
* Remove user:
```
gcloud iam service-accounts delete $ACCT_NAME@$TF_VAR_GCP_PROJECT.iam.gserviceaccount.com
```

#### Sources
* [GCP Terraform Walkthrough](https://www.middlewareinventory.com/blog/terraform-remote-state-datasource-example/)
* [Create IAM service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
* [Create IAM keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)