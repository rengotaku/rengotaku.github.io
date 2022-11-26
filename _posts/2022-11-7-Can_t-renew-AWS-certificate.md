# Problem
 Certificates validation of AWS didn't finish with terraform.
```
module.production_hoge_acm_default.aws_acm_certificate_validation.default[0]: Still creating... [33m20s elapsed]
```
I check status of them on [AWS web console](https://ap-northeast-1.console.aws.amazon.com/acm/home?region=ap-northeast-1#/certificates/list), then figure out that they were expired already.

# Solution
Disabled `aws_acm_certificate_validation` temporary.
[aws_acm_certificate_validation | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)

If your certificate was expired, you can't renew with terraform, so you have to do on AWS web console.