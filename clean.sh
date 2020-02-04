#! /bin/bash

if [ -s logs/buckets.txt ]; then
  cat logs/buckets.txt | xargs -I % aws s3 rm s3://% \
    --profile playground \
    --recursive

  cat logs/buckets.txt | xargs -I % aws s3api delete-bucket \
    --profile playground \
    --bucket %
  
  rm logs/buckets.txt
fi

if [ -s logs/stacks.txt ]; then
  cat logs/stacks.txt | xargs -I % aws cloudformation delete-stack \
    --profile playground \
    --stack-name %
  
  rm logs/stacks.txt
fi