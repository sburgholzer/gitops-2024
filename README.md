# GitOps with Terraform Mini-Camp 2024

This repository contains the completed project from the GitOps with Terraform Mini-Camp 2024, led by Derek Morgan and Andrew Brown. While starter code was provided by Derek at [Original Repo from More Than Certified](https://github.com/morethancertified/gitops-minicamp-2024-tf), the project involved fixing intentional bugs and implementing additional functionality through GitHub Actions.

## Table of Contents
- [GitOps with Terraform Mini-Camp 2024](#gitops-with-terraform-mini-camp-2024)
  * [Project Structure](#project-structure)
    + [CloudFormation](#cloudformation)
    + [Terraform](#terraform)
    + [Policies](#policies)
  * [GitHub Actions Workflows](#github-actions-workflows)
    + [Core Workflows](#core-workflows)
    + [Validation Workflows](#validation-workflows)
  * [Merging Strategy](#merging-strategy)
  * [Pre-commit Configuration](#pre-commit-configuration)
    + [Installation](#installation)
    + [Configured Hooks](#configured-hooks)
  * [Environment Configuration](#environment-configuration)
    + [Main Branch Protection](#main-branch-protection)
  * [Contributing](#contributing)
  * [Development Journal](#development-journal)
      - [10/13/24](#10-13-24)
      - [10/14/24](#10-14-24)
      - [10/15/24](#10-15-24)
      - [10/22/24](#10-22-24)
      - [10/26/24](#10-26-24)
      - [11/1/24](#11-1-24)
      - [11/2/24](#11-2-24)
      - [11/3/24](#11-3-24)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## Project Structure

### CloudFormation
- **OIDC Configuration**: Contains templates for configuring AWS OIDC authentication for GitHub Actions
- **Backend Resources**: Templates for creating S3 bucket and DynamoDB table for Terraform state management

### Terraform
- Infrastructure as Code implementation 
- Modified starter code with improvements for reliability and resilience
- Implements state management using S3 backend with DynamoDB locking

### Policies
- **cost.rego**: OPA policy to enforce cost limits
- **instance-policy.rego**: Controls allowed EC2 instance types

## GitHub Actions Workflows

### Core Workflows
- **tfplan.yml**: Runs terraform plan, saves the JSON and if it's a PR running it, create a comment with changes
  - GitHub Actions Used:
    - [configure-aws-credentials@v4](https://github.com/aws-actions/configure-aws-credentials)
    - [actions/checkout@v4](https://github.com/actions/checkout)
    - [hashicorp/setup-terraform@v3](https://github.com/hashicorp/setup-terraform)
    - [actions/upload-artifact@v4](https://github.com/actions/upload-artifact)
    - [open-policy-agent/setup-opa@v2](https://github.com/open-policy-agent/setup-opa)
    - [borchero/terraform-plan-comment@v2](https://github.com/borchero/terraform-plan-comment)
- **tfapply.yml**: This workflow runs when the repo owner or an admin comments the word "apply" to a PR to the main branch
  - GitHub Actions Used:
    - [xt0rted/pull-request-comment-branch@v2](https://github.com/xt0rted/pull-request-comment-branch)
    - [configure-aws-credentials@v4](https://github.com/aws-actions/configure-aws-credentials)
    - [actions/checkout@v4](https://github.com/actions/checkout)
    - [hashicorp/setup-terraform@v3](https://github.com/hashicorp/setup-terraform)
    - ~~[gliech/create-github-secret-action@v1](https://github.com/gliech/create-github-secret-action)~~
    - [actions/github-script@v7](https://github.com/actions/github-script)
- **tfdestroy.yml**: Manual workflow for infrastructure destruction
  - GitHub Actions Used:
    - [configure-aws-credentials@v4](https://github.com/aws-actions/configure-aws-credentials)
    - [actions/checkout@v4](https://github.com/actions/checkout)
    - [hashicorp/setup-terraform@v3](https://github.com/hashicorp/setup-terraform)

### Validation Workflows
- **tflint.yml**: Code linting with PR feedback
  - GitHub Actions Used:
    - [actions/checkout@v4](https://github.com/actions/checkout)
    - [actions/cache@v4](https://github.com/actions/cache)
    - [terraform-linters/setup-tflint@v4](https://github.com/terraform-linters/setup-tflint)
    - [peter-evans/find-comment@v3](https://github.com/peter-evans/find-comment)
    - [peter-evans/create-or-update-comment@v4](https://github.com/peter-evans/create-or-update-comment)
- **infracost.yml**: Cost analysis with OPA policy enforcement
  - GitHub Actions Used: 
    - [infracost/actions/setup@v3](https://github.com/infracost/actions/tree/v3/setup)
    - [actions/checkout@v4](https://github.com/actions/checkout)
    - [open-policy-agent/setup-opa@v2](https://github.com/open-policy-agent/setup-opa)
- **tfdrift.yml**: Infrastructure drift detection on a schedule
  - GitHub Actions Used:
    - [tfplan.yml](.github/workflows/tfplan.yml)
    - [actions/download-artifact@v4](https://github.com/actions/download-artifact)
    - [micalevisk/last-issue-action@v2](https://github.com/micalevisk/last-issue-action)
    - [dacbd/create-issue-action@main](https://github.com/dacbd/create-issue-action/tree/main/)
    - [peter-evans/create-or-update-comment@v4](https://github.com/peter-evans/create-or-update-comment)
- **grafana_port.yml**: Port accessibility monitoring on a schedule
  - GitHub Actions Used:
    - ~~[nrukavkov/open-ports-check-action@v1](https://github.com/nrukavkov/open-ports-check-action)~~ Didn't work as expected, changed method just to get around this issue for now.
    - [micalevisk/last-issue-action@v2](https://github.com/micalevisk/last-issue-action)
    - [dacbd/create-issue-action@main](https://github.com/dacbd/create-issue-action/tree/main/)
    - [peter-evans/create-or-update-comment@v4](https://github.com/peter-evans/create-or-update-comment)

## Merging Strategy
The merging strategy is apply before merge. The main branch of this repo is the source of truth. That's basically to say that is the stable branch, and it only is updated once checks pass and other potential reviews are done. So we create a PR to merge into the main branch, and three required checks (infracost, tflint, terraform plan) need to pass in order for a PR to be considered. Once the PR is passing and otherwise passes review of the maintainer(s), an apply is ran on the PR then it is merged once that apply is successful.

## Pre-commit Configuration

### Installation
```bash
pip install pre-commit
pre-commit install
```
### Configured Hooks
- terraform_fmt
- terraform_tflint

## Environment Configuration

### Main Branch Protection
- Required PR reviews
- Required status checks
- Automated validation

## Contributing
1. Create feature branch from development
2. Submit PR with proposed changes
3. Ensure all checks pass
4. Request review



## Development Journal
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
    ~~- Changed the environment block under jobs to
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
      This did create a new environment for us to use, however we don't have the `ROLE_TO_ASSUME` secret in this new environment. So added that secret to this new environment. Info found here: [Github Community](https://github.com/orgs/community/discussions/38178).~~

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

#### 10/22/24
- Created [tfapply.yml](.github/workflows/tfapply.yml) for a manual action to run terraform apply
- Created [tfdestroy.yml](.github/workflows/tfdestroy.yml) for a manual action to run terraform destroy
- Updated [terraform.tfvars](terraform/terraform.tfvars) to change from t3.micro to t2.micro due errors relating to it not being avaliable in a AZ
- While not using it, updated [main.tf](terraform/main.tf) to have a commented out check block for future reference
- Thanks to Derek's video, understood [infracost.yml](.github/workflows/infracost.yml) more, it was working as expected, I was trying to be too "extra"!
- added [cost.rego](policies/cost.rego) for an OPA policy to fail infracost if price change > $10
- updated [infracost.yml](.github/workflows/infracost.yml) to use this OPA policy

#### 10/26/24
- Created [instance-policy.rego](policies/instance-policy.rego) to allow only certain instance types
- Created [tfplan.yml](.github/workflows/tfapply.yml) to use this new policy
  - Deactivated the workflow in Actions that uses [terraform.yml](.github/workflows/terraform.yml) to use the new workflow yml

#### 11/1/24
- Ensured all TF Variables are passed in via GitHub Actions
- Added default tags to the provider block in [providers.tf](terraform/providers.tf)
- Installed pre-commit
  ```
  pip install pre-commit
  pre-commit install
  ```
- Installed TFlint in codespaces
- created the [.pre-commit-config.yaml](.pre-commit-config.yaml) file
  - added terraform_fmt and terraform_tflint as hooks
  - Would want to potentially add tfsec, tfvalidate, tf_docs, etc for additional checks, but to turn this project in ASAP I did install them
- Modified [tfdrift.yml](.github/workflows/tfdrift.yml) with help of Google and some AI. It worked as I had deleted the EC2 instance via AWS console, thus causing a drift in Terraform. I temporarily had this workflow set up with a manual innovaction for testing, and it picked up the drift I made and opened an issue!

#### 11/2/24
- added [garfana_port.yml](.github/workflows/garfana_port.yml) to check if the port for Garfana is accessible.
- RE: drift detection and garfana port, I thought there were two options, to fail the workflow if there is a drift/port problem, or succeed the workflow. As I am creating issues within the two workflows, I decided I'd make the workflow be successful as long as it followed all the steps without issue since we would be opening an issue in GitHub for the workflows. If I were not opening these issues, then I would of made the workflows fail.

#### 11/3/24 into early morning hours of 11/4/24
- Finished [garfana_port.yml](.github/workflows/garfana_port.yml)
- Found a way to add comments to existing issues (port check and drift check) and not keep creating duplicate issues
- Updated workflows to run in different environments
- Implemented running on different environments
- Updated [tfplan.yml](.github/workflows/tfplan.yml) to comment useful info to the PR
- Updated [tflint.yml](.github/workflows/tflint.yml) to comment useful info to the PR
- Updated [tfapply.yml](.github/workflows/tfapply.yml) to run only when repo owner or admin types apply in a PR request
- Tidy up and finish README documentation
- Submitted for grading