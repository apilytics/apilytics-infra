# Apilytics Infra 📈

[![ci](https://github.com/blomqma/apilytics-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/blomqma/apilytics-infra/actions)

### What is managed manually?

#### S3

- `apilytics-terraform-state` S3 bucket, and some lifecycle policy rules for it that delete old plan files.

#### DynamoDB

- `apilytics-terraform-lock` DynamoDB table, spun up with the default recommended settings.

#### IAM

- `apilytics-infra-user` IAM user whose access keys are used in this repo's pipelines.
- `apilytics-smtp-user` IAM user and its SMTP credentials.
- All human-accessed IAM users and all IAM access credentials.

#### SES

- SES domain verification.
- Moving out of the SES sandbox by requesting it from AWS support.
