# SYNTASA Installation using Google Marketplace Toolkit (mpdev)

### Prerequisites
Please read through the prerequisites document here:

[Syntasa Prerequisites](PREREQUISITES.md)

### Installing the Google Marketplace Toolkit

Once Docker is installed, extract the mpdev toolkit to simulate a Marketplace like deployment environment

Pull the MPDEV docker image:
```
sudo docker pull gcr.io/cloud-marketplace-tools/k8s/dev
```

Install MPDEV tools:
```
BIN_FILE="$HOME/bin/mpdev"
docker run \
  gcr.io/cloud-marketplace-tools/k8s/dev \
  cat /scripts/dev > "$BIN_FILE"
chmod +x "$BIN_FILE"
```

### Verify Installation of the Google Marketplace Toolkit

Run the following to diagnose and validate setup your environment:
```
mpdev /scripts/doctor.py
```

### Install CRD

To run this kind of app, k8s needs CRD installed

to apply CRD from the google marketplace k8s toolkit:
```
git clone https://github.com/GoogleCloudPlatform/marketplace-k8s-app-tools.git
cd marketplace-k8s-app-tools/crd
kubectl apply -f app-crd.yaml
```
or you can apply configuration directly:
```
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml
```
---
#

### Cloning the repo
Clone the repo located here: https://github.com/syntasa-dev/syntasa-google-marketplace-sentiment-anlytics.git

Place it somewhere on your machine e.g. ~/home/<my_user>/

Once cloned or downloaded, please cd into the syntasa-google-marketplace directory

```
cd ~/home/<my_user>/syntasa-google-marketplace-sentiment-anlytics
```

Make the Deployer file executable
```
chmod +x deploy.sh
```

Export the Registry env variables
```
export REGISTRY=gcr.io/syntasa-public
export DEPLOYER_TAG=7.1.2
export TAG=latest
export APP_NAME=syntasa-behaviorial-sentiment-analytics
```

### Gathering the required properties
When running the MPDEV installation, the following properties must be set

```
{
    "name": "test-deployment",
    "namespace": "syntasa",
    "jobName": "syntasa-package",
    "job.ttlSecondsAfterFinished": 300,
    "job.activeDeadlineSeconds": 300,
    "job.serviceAccountName": "sma-sa",
    "imagePullSecrets.name": "syn-creds",
    "imageRepo": "syntasadevelopment",
    "installerVersion": "7.1.2",
    "project": "syntasa-dev",
    "pullFromDockerhub": true,
    "haproxyName": "syntasa-ingress",
    "haproxy.serviceAccountName": "sma-sa",
    "haproxy.service.loadBalancerIP": "",
    "haproxy.service.loadBalancerSourceRanges": "",
    "configMap.name": "syntasa-ingress-conf",
    "secrets.docker.username": "",
    "secrets.docker.password": "",
    "secrets.certName": "sma-certs",
    "management.name": "syntasa-management-console",
    "management.ingress.name": "syntasa-management-console",
    "management.ingress.tls.host": "",
    "management.ingress.tls.secretName": "sma-certs"
}
```

### Running the MPDEV Installation
To run the Install type:
```
 mpdev install --deployer=$REGISTRY/$APP_NAME/deployer:$DEPLOYER_TAG --parameters='{
    "name": "test-deployment",
    "namespace": "syntasa",
    "jobName": "syntasa-package",
    "job.ttlSecondsAfterFinished": 300,
    "job.activeDeadlineSeconds": 300,
    "job.serviceAccountName": "sma-sa",
    "imagePullSecrets.name": "syn-creds",
    "imageRepo": "syntasadevelopment",
    "installerVersion": "7.1.2",
    "project": "syntasa-dev",
    "pullFromDockerhub": true,
    "haproxyName": "syntasa-ingress",
    "haproxy.serviceAccountName": "sma-sa",
    "haproxy.service.loadBalancerIP": "",
    "haproxy.service.loadBalancerSourceRanges": "",
    "configMap.name": "syntasa-ingress-conf",
    "secrets.docker.username": "",
    "secrets.docker.password": "",
    "secrets.certName": "sma-certs",
    "management.name": "syntasa-management-console",
    "management.ingress.name": "syntasa-management-console",
    "management.ingress.tls.host": "",
    "management.ingress.tls.secretName": "sma-certs"
}'```


### Deploying your changes
Please see the deploy script located here: 
> [SYNTASA Deploy Script](../deploy.sh)
---


When ready, please head to the static ip you reserved as follows: https://<my_static_ip>

Installation will take anywhere from 10 seconds to 2 minutes.

