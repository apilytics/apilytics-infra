#!/bin/sh

# Get the the latest tag in the given ECR repo.
# If the repo doesn't exist yet or there are no images in it, just return `latest` as a dummy value.
# Returns the output as a JSON since that's what Terraform's `external` provider needs.

tag="$(aws ecr describe-images --repository-name="$1" --query='sort_by(imageDetails,&imagePushedAt)[-1].imageTags[0]' --output=text 2> /dev/null)"

if [ -z "$tag" ] || [ "$tag" = 'None' ]; then
  tag="latest"
fi

echo "{\"tag\":\"$tag\"}"
