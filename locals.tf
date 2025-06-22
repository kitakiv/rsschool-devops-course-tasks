locals {
  ingress_rules = [{
    port        = 443
    rule_no     = 100
    description = "Ingress rules for port 443"
    tag = "100 rule for port 443"
    },
    {
      port        = 80
      rule_no     = 200
      description = "Ingress rules for port 80"
      tag = "200 rule for port 80"
  }]
}