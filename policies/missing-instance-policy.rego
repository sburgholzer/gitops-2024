package terraform
import rego.v1

deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_instance"
    resource.change.actions[_] == "create"
    resource.change.actions[_] == "delete"
    msg := sprintf(
        "🚨 Drift detected: EC2 instance '%s' was deleted outside of Terraform and needs to be recreated",
        [resource.address]
    )
}