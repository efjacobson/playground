#! /bin/bash

if [ -z "$1" ]; then
  echo "gotta enter a name bro"
  exit 1
fi

aws cloudformation delete-stack \
  --profile playground \
  --stack-name "$1"