#!/bin/bash

REPO_NAME=radpenguin/unionfs-mount

BUILD_DATE=$( date +"%Y-%m-%d-%H-%M-%S" )

docker build \
  --no-cache \
  --build-arg=BUILD_DATE="$BUILD_DATE" \
  --tag=$REPO_NAME \
  .

docker push $REPO_NAME
