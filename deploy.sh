#!/usr/bin/env bash
export PROJECT="$(gcloud config get-value project | tr ':' '/')"
export REGISTRY=gcr.io/syntasa-public
export DEPLOYER_TAG_SEM=8.2
export DEPLOYER_TAG=8.2.2
export TAG=8.2.2
export APP_NAME=syntasa-behaviorial-sentiment-analytics

docker build \
--build-arg REGISTRY=$REGISTRY \
--build-arg APP_NAME=$APP_NAME \
--build-arg TAG=$TAG \
--build-arg PROJECT=$PROJECT \
--tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM .

docker build \
--build-arg REGISTRY=$REGISTRY \
--build-arg APP_NAME=$APP_NAME \
--build-arg TAG=$TAG \
--build-arg PROJECT=$PROJECT \
--tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG .

docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM
docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG
