package spacelift

deny[msg] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_security_group"
    configuration := resource.change.after
    configuration.ingress[_].protocol == "-1"
    msg = "Protocol '-1' ingress is not allowed for security groups."
}

deny[msg] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_security_group"
    configuration := resource.change.after
    configuration.ingress[_].from_port == 0
    msg = "Port 0 ingress is not allowed for security groups."
}

deny[msg] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_security_group"
    configuration := resource.change.after
    ingress = configuration.ingress[_]
    ingress.from_port != ingress[_].to_port
    msg = "Port range ingress is not allowed for security groups."
}

deny[msg] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_security_group"
    configuration := resource.change.after
    configuration.ingress[_].cidr_blocks[_] == "0.0.0.0/0"
    msg = "Public ingress from 0.0.0.0/0 is not allowed for security groups."
}
