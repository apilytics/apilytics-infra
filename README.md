# Apilytics Infra 📈

[![ci](https://github.com/blomqma/apilytics-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/blomqma/apilytics-infra/actions)

### What is managed manually?

- `apilytics-terraform-state` S3 bucket, and some lifecycle policy rules for it that delete old plan files.

- `apilytics-terraform-lock` DynamoDB table, spun up with the default recommended settings.

- `apilytics-infra` IAM user whose access keys are used in this repo's pipelines.

- All human-accessed IAM users and all IAM access credentials.
