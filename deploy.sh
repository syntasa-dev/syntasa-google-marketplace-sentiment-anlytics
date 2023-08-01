#!/usr/bin/env bash
export PROJECT="$(gcloud config get-value project | tr ':' '/')"
export REGISTRY=gcr.io/syntasa-public
export DEPLOYER_TAG_SEM=7.1-test
export DEPLOYER_TAG=7.1.2-test
export TAG=latest
export APP_NAME=syntasa-behaviorial-sentiment-analytics

docker run -it --rm -v $(pwd)/chart:/chart --entrypoint /bin/sh alpine/helm:3.12.2 -c \
                "helm repo add syntasa-dev https://syntasa-dev.github.io/syntasa-charts/ && \
                helm pull syntasa-dev/syntasa --untar -d /chart"

docker build \
--build-arg REGISTRY=$REGISTRY \
--build-arg APP_NAME=$APP_NAME \
--build-arg TAG=$TAG \
--build-arg PROJECT=$PROJECT \
--tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM .

# docker build \
# --build-arg REGISTRY=$REGISTRY \
# --build-arg APP_NAME=$APP_NAME \
# --build-arg TAG=$TAG \
# --build-arg PROJECT=$PROJECT \
# --tag $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG .

# docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG_SEM
# docker push $REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG
