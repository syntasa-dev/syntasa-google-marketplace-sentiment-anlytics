#!/usr/bin/env bash
export PROJECT="$(gcloud config get-value project | tr ':' '/')"
export REGISTRY=gcr.io/syntasa-public
export DEPLOYER_TAG_SEM=8.2
export DEPLOYER_TAG=8.2.1
export TAG=8.2.1
export APP_NAME=syntasa-behaviorial-sentiment-analytics

docker build --platform linux/amd64 \
  --build-arg REGISTRY=$REGISTRY \
  --build-arg APP_NAME=$APP_NAME \
  --build-arg TAG=$TAG \
  --build-arg PROJECT=$PROJECT \
  --tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM .

docker build --platform linux/amd64 \
  --build-arg REGISTRY=$REGISTRY \
  --build-arg APP_NAME=$APP_NAME \
  --build-arg TAG=$TAG \
  --build-arg PROJECT=$PROJECT \
  --tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG .

docker build --platform linux/amd64 \
  --build-arg REGISTRY=$REGISTRY \
  --build-arg APP_NAME=$APP_NAME \
  --build-arg TAG=$TAG \
  --build-arg PROJECT=$PROJECT \
  --tag $REGISTRY/$APP_NAME:$DEPLOYER_TAG_SEM .

docker build --platform linux/amd64 \
  --build-arg REGISTRY=$REGISTRY \
  --build-arg APP_NAME=$APP_NAME \
  --build-arg TAG=$TAG \
  --build-arg PROJECT=$PROJECT \
  --tag $REGISTRY/$APP_NAME:$DEPLOYER_TAG .

# Push the built images
docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM
docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG

docker push $REGISTRY/$APP_NAME:$DEPLOYER_TAG_SEM
docker push $REGISTRY/$APP_NAME:$DEPLOYER_TAG


docker manifest inspect $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM
