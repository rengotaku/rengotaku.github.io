# How
You execute below and could login correctly, you would be said `Login Succeeded`.
```
aws ecr get-login-password --profile profile | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
```
You have to change `profile` (or not using) and `aws url`.
(Username is fiexed, though.)

 Could be know `aws url`  from the URI at Repositories Images page of AWS Management Console.

If you finished work, you should `docker logout`.

# References
[Using Amazon ECR with the AWS CLI - Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html#cli-authenticate-registry)