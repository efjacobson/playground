#! /bin/bash

if [ -z "$1" ]; then
  echo "gotta enter a name bro"
  exit 1
fi

BUCKET_ID="$1playgroundbucket$(date +%s)"
BUCKET="s3://${BUCKET_ID}"

aws s3 mb $BUCKET \
  --profile playground

sed -i'.original' -e "s/BUCKETIDREPLACETOKEN/${BUCKET_ID}/g" cloudformation/infra.yaml

aws s3 sync cloudformation/. $BUCKET \
  --profile playground \
  --delete

aws cloudformation deploy \
  --profile playground \
  --stack-name "$1" \
  --template-file cloudformation/infra.yaml \
  --capabilities CAPABILITY_IAM

rm cloudformation/infra.yaml
mv cloudformation/infra.yaml.original cloudformation/infra.yaml