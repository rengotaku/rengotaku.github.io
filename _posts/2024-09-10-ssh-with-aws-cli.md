---
title: "AWS CLIを利用してEC2のIPを取得して接続"
tags: ["aws", "cli", "ec2", "sso"]
---

# 参考
* [describe-target-groups — AWS CLI 1.34.15 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/elbv2/describe-target-groups.html#description)
* [describe-target-health — AWS CLI 1.34.14 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/elbv2/describe-target-health.html)
* [describe-instances — AWS CLI 1.34.14 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html)
* [Get the public ip address of your EC2 instance quickly | Towards the Cloud](https://towardsthecloud.com/get-ip-address-amazon-ec2-instance)

# 前置き
EC2のIPをAWSコンソールなりで確認して接続していたがいい加減煩わしくなった。
tagがEC2インスタンスに適切に設定されておらず、ALBのターゲットグループの紐付きからEC2を特定する方式をとった。(tagが設定されていればもっとスマートに書けた)

# 事前設定
SSOログインを利用しています。`~/.aws/config`に下記を定義している。
```
[profile hoge-profile]
sso_start_url = https://hoge.awsapps.com/start#
sso_region = us-east-1
sso_account_id = 123456789
sso_role_name = HogeAccess
region = ap-northeast-1
output = json
```

SSHのconfigに下記のような定義を記載している。

```
Host hoge-production
  HostName 10.0.0.1
  ProxyCommand ssh -W %h:%p hoge-production-bastion
```

# Output
`~/.zprofile`などに下記のaliasとfunctionを定義します。

```
########################
# Auto connect AWS EC2 instance
########################
alias ssh-hoge-prod='ssh_ec2_with_private_ip hoge-profile hoge-production "arn:aws:elasticloadbalancing:ap-northeast-1:12346789:targetgroup/hoge-production-tg/12346789"'

# $1: profile名, $2: SSH configのHost, $3: ALBのARN
ssh_ec2_with_private_ip() {
  export AWS_PROFILE=$1
  echo "Log in using 'aws sso login --profile $AWS_PROFILE' before using this."

  export TARGET_GROUP_ARN=$3
  export INSTANCE_ID=$(aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN | \
  jq -r '.TargetHealthDescriptions[0] | .Target.Id')

  export EC2_PRIVATE_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'Reservations[*].Instances[*].PrivateIpAddress' | \
  jq -r '.[][]')

  ssh -o "Hostname=$EC2_PRIVATE_IP" $2
}
```
