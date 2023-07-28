# SYNTASA Google Cloud Marketplace Configuration Options

## Common Parameters

The following parameters are commonly used in the SYNTASA configuration:

**Name**

Specifies the name of the deployment. Example: 'test-deployment'

**Namespace**

The Kubernetes namespace where SYNTASA is deployed. Example: 'syntasa'

**Reporting Secret**

The Kubernetes secret used to authenticate the pricing sidecar

**GCP Service Account**

The service account that is impersonated in GKE for identity workload authentication.

**Load Balancer Hostname**

The host name for the Syntasa Ingress.

**HAProxy Service Load Balancer IP**

Specifies the IP address that the HAProxy service will use. If left empty, an IP address will be automatically assigned.

**HAProxy Service Load Balancer Source Ranges**

Specifies the IP address ranges that are allowed to connect to the HAProxy service.


Please include these parameters in the YAML configuration when deploying the SYNTASA app.

## Accessing the SYNTASA Management Console UI

Once you hit the "Deploy button" in the Google Marketplace SYNTASA Management Console, please allow a few minutes for all services to be deployed and ready.  To access the SYNTASA Management Console UI, please follow the below guidance:

Get the static IP you specified in the 'IP Address of Reserved External IP' field, then your application URL link will be as follows:
    - https://<your_static_ip>/management

For any further questions or help, please contact `info@syntasa.com` or `help@syntasa.com`
