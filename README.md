# GitOps with Terraform 2024 Starter Code

## Cloudformation

The code in the ./cloudformation directory is optional. It is to configure the OIDC role used to authenticate your GitHub Actions workflows to AWS. 

## Terraform

The code in the ./terraform directory is the starter code for the course. This code isn't perfect, and that's intentional! You may need to make modifications to ensure it is reliable and resilient. 

[Original Repo from More Than Certified](https://github.com/morethancertified/gitops-minicamp-2024-tf)


#### 10/13/24

- the `required_version` was missing in [versions.tf](terraform/versions.tf), and thus causing linter to fail. 
    - added `requried_version` and used `>= 1.9.0` to have the latest changes to terraform
- variable types were missing in [variables.tf](terraform/variables.tf), and thus causing [linter job](.github/workflows/tflint.yml) to fail.
    - added `type = string` to both variables
- after fixing the two (well three as there were two variables) issues above, tflint job passed!
- The [terraform.yml](.github/workflows/terraform.yml) job kept failing for a while on `terraform -chdir="./terraform" fmt -check` even though I was running `terraform fmt` manually
    - Turns out it helps to be in the terraform directory to run `terraform fmt`... after that that, the job passed until the no credentials found, which is to be expected. Waiting on the video on OIDC setup (though I've done it before, but don't remember all the steps!)
- Updated [terraform.yml](.github/workflows/terraform.yml) to default to the terraform directory and removed all `-chdir="./terrafrom"` from the terraform commands to clean it up and in case any new steps added, don't have to remember to add that to the command.


#### 10/14/24
- Followed Derek's video on setting up OIDC
    - used the [oidc-role.yaml](cfn/oidc-role.yaml) template and created a template in CloudFormation and created a stack.
        - This created the OIDC Connection and a role for this repository
    - updated [terraform.yml](.github/workflows/terraform.yml) to add a new step at the very top of all steps to use `aws-actions/configure-aws-credentials@v4` and including the role ARN to assume and the region to use
        - to add security to our workflow, we added the role ARN to the production environment secrets in GitHub.
        - First time we ran this, it failed with message `It looks like you might be trying to authenticate with OIDC. Did you mean to set the id-token permission? If you are not trying to authenticate with OIDC and the action is working successfully, you can ignore this message.`
            - to fix this: add `id-token: write` to the permissions section within [terraform.yml](.github/workflows/terraform.yml)