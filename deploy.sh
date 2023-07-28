#!/usr/bin/env bash
#export REGISTRY=gcr.io/$(gcloud config get-value project | tr ':' '/')
export REGISTRY=gcr.io/syntasa-public
export DEPLOYER_TAG=7.1.2
export TAG=latest
export APP_NAME=syntasa-behaviorial-sentiment-analytics

docker build \
--build-arg REGISTRY=$REGISTRY \
--build-arg APP_NAME=$APP_NAME \
--build-arg TAG=$TAG \
--tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG .

docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG