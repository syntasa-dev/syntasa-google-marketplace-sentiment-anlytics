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
export DEPLOYER_TAG=8.2.2
export TAG=8.2.2
export APP_NAME=syntasa-behaviorial-sentiment-analytics
```

### Gathering the required properties
When running the MPDEV installation, the following properties must be set

```
{
    "name": "test-deployment",
    "namespace": "syntasa",
    "reportingSecret": "gs://cloud-marketplace-tools/reporting_secrets/fake_reporting_secret.yaml",
    "gcpServiceAccount": "syntasa-marketplace-dev@syntasa-dev.iam.gserviceaccount.com",
    "haproxy.service.loadBalancerHostname": "",
    "haproxy.service.loadBalancerIP": "35.245.96.107",
    "haproxy.service.loadBalancerSourceRanges": "0.0.0.0/0"
}
```

### Running the MPDEV Installation
To run the Install type:
```
mpdev install --deployer=gcr.io/syntasa-public/syntasa-behaviorial-sentiment-analytics/deployer:8.2.2 --parameters='{
    "name": "test-deployment",
    "namespace": "syntasa",
    "reportingSecret": "gs://cloud-marketplace-tools/reporting_secrets/fake_reporting_secret.yaml",
    "gcpServiceAccount": "syntasa-marketplace-dev@syntasa-dev.iam.gserviceaccount.com",
    "haproxy.service.loadBalancerHostname": "",
    "haproxy.service.loadBalancerIP": "35.245.96.107",
    "haproxy.service.loadBalancerSourceRanges": "0.0.0.0/0"
}'
```


### Deploying your changes
Please see the deploy script located here: 
> [SYNTASA Deploy Script](../deploy.sh)
---


When ready, please head to the static ip you reserved as follows: https://<my_static_ip>

Installation will take anywhere from 10 seconds to 2 minutes.

