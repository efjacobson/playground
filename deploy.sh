#! /bin/bash

DATE=$(date +%s)

if [ -z "$1" ]; then
  STACKNAME='coolstack'
else
  STACKNAME=$1
fi

echo "${STACKNAME}" >> logs/stacks.txt

BUCKET_ID="${STACKNAME}playgroundbucket${DATE}"
BUCKET="s3://${BUCKET_ID}"

echo "${BUCKET_ID}" >> logs/buckets.txt

aws s3 mb $BUCKET \
  --profile playground

mkdir temp
ls cloudformation >> temp/templateList.txt

cat temp/templateList.txt | xargs -I % sed -i'.original' -e "s/BUCKETIDREPLACETOKEN/${BUCKET_ID}/g" cloudformation/%

aws s3 sync cloudformation/. $BUCKET \
  --profile playground \
  --delete \
  --exclude "*" \
  --include "*.yaml"

aws cloudformation deploy \
  --profile playground \
  --stack-name "${STACKNAME}" \
  --template-file cloudformation/infra.yaml \
  --capabilities CAPABILITY_IAM

cat temp/templateList.txt | xargs -I % rm cloudformation/%
cat temp/templateList.txt | xargs -I % mv cloudformation/%.original cloudformation/%
rm -rf temp