## Terraform test cases

How to run one of the Terraform test cases:

* Create a file in the project top dir with name `terraform.tfvars` and the following content:
  ```hcl
  secret_key="<secret_key_data>"
  access_key="<access_key_data>"
  ec2_url="<ec2_url>"
  az="<default_az_name>"
  subnet_id="<default_subnet_id>"
  ```
* Run Terraform `plan` and `apply` command for specified case:
  ```sh
  $ make plan-<subfolder_name_in_cases_folder>
  $ make apply-<subfolder_name_in_cases_folder>
  ```
