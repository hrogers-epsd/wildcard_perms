package spacelift

deny[message] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_iam_policy"
    json.unmarshal(resource.change.after.policy, policy_)
    statement := policy_.Statement[_]
    regex.match("\\*", statement.Action)
    message := sprintf(
        "IAM policy '%s' contains a wildcard permission ('*') in Action",
        [resource.name]
    )
}
