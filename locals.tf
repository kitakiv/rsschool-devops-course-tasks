locals {
  ingress_rules = [{
    port        = 443
    rule_no     = 100
    description = "Ingress rules for port 443"
    tag         = "100 rule for port 443"
    cidr_block  = "0.0.0.0/0",
    protocol    = "tcp"
    },
    {
      port        = 80
      rule_no     = 200
      description = "Ingress rules for port 80"
      tag         = "200 rule for port 80"
      cidr_block  = "0.0.0.0/0",
      protocol    = "tcp"
    },
    {
      port        = 22
      rule_no     = 300
      description = "Ingress rules for port 22"
      tag         = "300 rule for port 22"
      cidr_block  = "0.0.0.0/0",
      protocol    = "tcp"
  }]
}