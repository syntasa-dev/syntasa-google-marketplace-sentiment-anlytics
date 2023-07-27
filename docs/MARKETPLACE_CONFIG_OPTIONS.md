# SYNTASA Google Cloud Marketplace Configuration Options

## Common Parameters

The following parameters are commonly used in the SYNTASA configuration:

**Name**

Specifies the name of the deployment. Example: 'test-deployment'

**Namespace**

The Kubernetes namespace where SYNTASA is deployed. Example: 'syntasa'

**Job Service Account Name**

The service account that the job will use to run. Example: 'sma-sa'

**Image Pull Secrets**

The secret used to pull Docker images. This is often necessary if your Docker images are hosted in a private repository. Example: 'syn-creds'

**Image Repo**

Specifies the Docker repository where SYNTASA's images are stored. Example: 'syntasadevelopment'

**Installer Version**

The version of SYNTASA to be deployed. Example: '7.1.2'

**Project**

Specifies the Google Cloud Project where the deployment will occur. Example: 'syntasa-dev'

**Pull From Dockerhub**

A boolean flag that determines whether or not to pull Docker images from Docker Hub. If set to true, images will be pulled from Docker Hub. If false, images will be pulled from the image repository specified by 'imageRepo'. Example: true

**HAProxy Service Account Name**

The service account that the HAProxy service will use to run. Example: 'sma-sa'

**HAProxy Service Load Balancer IP**

Specifies the IP address that the HAProxy service will use. If left empty, an IP address will be automatically assigned.

**HAProxy Service Load Balancer Source Ranges**

Specifies the IP address ranges that are allowed to connect to the HAProxy service.

**Secrets Cert Name**

The name of the secret that contains the certificates used for SSL/TLS. Example: 'sma-certs'

**Management Ingress TLS Host**

The host name for the Management Ingress TLS.

**Management Ingress TLS Secret Name**

The name of the secret that contains the certificates used for SSL/TLS in the management ingress. Example: 'sma-certs'

Please include these parameters in the YAML configuration when deploying the SYNTASA app.

## Accessing the SYNTASA Management Console UI

Once you hit the "Deploy button" in the Google Marketplace SYNTASA Management Console, please allow a few minutes for all services to be deployed and ready.  To access the SYNTASA Management Console UI, please follow the below guidance:

1. If you specified a static IP in the 'IP Address of Reserved External IP' field, then your application URL link will be as follows:
    - https://<your_static_ip>/management
2. If you allowed the default empty value to remain, then the SYNTASA application will choose an ephemeral IP to use and your URL link will need to be gathered by:
    - Navigate to the Services & Ingresses page
    - Locate the 'syntasa-ingress' load balancer 
    - Copy the IP address and navigate to it in a new browser tab.
    - Your IP will be in the format https://<some_ephemeral_ip>/management

For any further questions or help, please contact `info@syntasa.com` or `help@syntasa.com`
