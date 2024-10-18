# GitOps with Terraform 2024 Starter Code

## Cloudformation

The code in the ./cloudformation directory is optional. It is to configure the OIDC role used to authenticate your GitHub Actions workflows to AWS. 

## Terraform

The code in the ./terraform directory is the starter code for the course. This code isn't perfect, and that's intentional! You may need to make modifications to ensure it is reliable and resilient. 

[Original Repo from More Than Certified](https://github.com/morethancertified/gitops-minicamp-2024-tf)

## Workflows

### GitHub Actions used in terraform.yml
[terraform.yml](.github/workflows/terraform.yml)

- [aws-actions/configure-aws-credentials@v4](https://github.com/aws-actions/configure-aws-credentials/tree/v4/)
- [actions/checkout@v4](https://github.com/actions/checkout/tree/v4/)
- [hashicorp/setup-terraform@v3](https://github.com/hashicorp/setup-terraform/tree/v3/)


## Journal of activities taken
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
- created CloudFormation stack via [backend-resources.yaml](cfn/backend-resources.yaml)
    - First time I ran through creating the stack and left the default S3 Bucket Name. Well I was in autopilot, so I didn't even think about making it a unique name as S3 requires. So the first attempt failed. I ran it again, but added -scott to the end of the default bucket name and it worked (like it should of if I had actually remembered...)
- Protecting main branch from commits/pushes if no Pull Request. I set up a classic branch protection under settings->Code and automation->Branches. Set the Branch name pattern to main, and selected Require a pull request before merging. I then tested it, however I was able to push directly to main, which I did not want. Turns out I needed to select the Do not allow bypassing the above settings to prevent myself (the owner of the repo) from pushing to the main branch. ~~There is also rulesets under settings->code and automation-> Rules. This would allow additional settings, but at this time, I do not see a need to look into those further.~~ (see activities from 10/15/24)
- In [terraform.yml](.github/workflows/terraform.yml) 
    - Changed the on block to: 
      ```
      on:
       push:
         branches: ['development]
       pull_request:
         branches ['main']
      ```
    - Changed the environment block under jobs to
      ```
      ...
      environment: |-
        ${{
            github.ref_name == 'main'        && 'production'
        || github.ref_name == 'development' && 'development'
        ||                                     'staging'
        }}
      ...
      ```
      This did create a new environment for us to use, however we don't have the `ROLE_TO_ASSUME` secret in this new environment. So added that secret to this new environment. Info found here: [Github Community](https://github.com/orgs/community/discussions/38178).

#### 10/15/24
- In [terraform.yml](.github/workflows/terraform.yml), changed the default evnironment from staging to development
- Deleted the classic rule set for protecting main branch
- Created, using the newer method, to protect main branch
  - Settings->Code and Automation->Rules->Rulesets
  - branch matching pattern was set to `main`
  - Enabled `Require a pull request before merging`
  - Enabled `Require status checks to pass`
    - When adding checks, you can search for your GitHub Action workflows and use them, so currently Terraform and TFlint workflows are the checks.
  - Updated our S3 backend in [versions.tf](terraform/versions.tf) to use [Partial Configuration](https://developer.hashicorp.com/terraform/language/backend#partial-configuration)
  - Updated [terraform.yml](.github/workflows/terraform.yml) to use these global env vars for Partial Configuration for S3 backend in terraform:
    ```env:
        TF_VAR_BACKEND_BUCKET: ${{ vars.BUCKET_NAME }}
        TF_VAR_BACKEND_KEY: ${{ vars.STATE_KEY }}
        TF_VAR_BACKEND_REGION: ${{ vars.REGION }}
        TF_VAR_BACKEND_DYNAMODB_TABLE: ${{ vars.DYNAMODB_NAME }}
    ```
  - Updated [terraform.yml](.github/workflows/terraform.yml) terraform init step to:
    ```
    - name: Terraform Init
      run: |
        terraform init \
          -backend-config="bucket=${TF_VAR_BACKEND_BUCKET}" \
          -backend-config="key=${TF_VAR_BACKEND_KEY}" \
          -backend-config="region=${TF_VAR_BACKEND_REGION}" \
          -backend-config="encrypt=true" \
          -backend-config="dynamodb_table=${TF_VAR_BACKEND_DYNAMODB_TABLE}"
    ```

#### 10/18/24
- added in [branchpolicy.yml](.github/workflows/branchpolicy.yml) to prevent PRs to Main if it is not from the staging branch.