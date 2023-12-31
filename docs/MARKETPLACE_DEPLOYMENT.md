# SYNTASA Google Marketplace Deployment

## Process Overview

1. [Obtaining a License](#obtaining-a-license)
2. [Pre-deployment Instructions](#pre-deployment-instructions)
3. [Deployment Instructions](#deployment-instructions)

For a successful deployment from the Google Cloud Console Marketplace, please follow the following steps before attempting
to install from the Marketplace.

`Before beginning, please make sure you have at least Project Editor access to the Project in which you wish to install the SYNTASA application from the marketplace.  If you are unsure about your accesses, please contact your Cloud Devops or IT administrator.`

---
## Obtaining a license

Please see the following document to obtain a license for the SYNTASA platform.
[`SYNTASA License Information`](SYN_LICENSE_INFO.md)

---

## Pre-deployment Instructions

### Enabling API's

To use all the services required by the SYNTASA application, please enable a few of the API's to get started.

1. Launch the Google Cloud Console - [GCP Console](https://console.cloud.google.com/)
2. Make sure you're logged into the console with the correct credentials (to change, click the profile icon on the top right of the screen)
3. Navigate to the correct project by clicking on the project drop-down menu in the top bar (next to the text that says 'Google Cloud Platform')
4. Using the hamburger icon on the top left of the console, navigate to the 'APIs & Services' tab
5. Click the 'Enable APIs and Services' button on the top bar
6. In the search bar, please search for the 'Kubernetes Engine API'. *Note: this API might be enabled by default in your project. If this is the case, you will not see an 'Enable' button.*
7. Click 'Enable'
8. Repeat Steps 5 through 7 for 'Cloud SQL Admin API'
9. Repeat Steps 5 through 7 for 'Cloud Dataproc API'

---

### Create an IAM Account

In order to ensure the Kubernetes cluster we create has the correct permissions, please create a IAM Service Account

1. Using the Hamburger icon on the top left of the Console, navigate to the 'IAM & Admin' page.
2. Click on 'Service Accounts' tab
3. Click the 'Create Service Account' button on the top menu bar
4. Fill in the 'Service Account Name' field with a name of your choice, e.g. 'syntasa-application-serviceacc'
5. Fill in the 'Service Account Description' field with a description of your choice, e.g. 'Service Account for SYNTASA Deployment'
6. Click the 'Create' button at the bottom to continue to the next page.
7. On the 'Service Account Permissions' page please add the following roles to the service account<br><br>
    To Add a role, click on the 'Select role' field and type one of the following roles into the search box that   appears. To continue adding roles, click on 'Add Another Role' and continue until all roles have been added.<br><br>
    * `BigQuery Admin`
    * `Cloud SQL Admin`
    * `Compute Admin`
    * `Kubernetes Engine Cluster Admin`
    * `Kubernetes Engine Developer`
    * `Kubernetes Engine Service Agent`
    * `Dataprc Administrator`
    * `Dataproc Worker`
    * `Service Account User`
    * `Storage Admin`<br><br>
8. Once all roles have been added, click the 'Continue' button
9. Leave the 'Service Account users role' and 'Service account admins role' blank.
10. (OPTIONAL) if you wish to create a JSON key, please click the 'Create Key' button
11. Click the 'Done' button and  **TAKE NOTE: 'email address of your service account', you will need this later when creating the Kubernetes cluster and deploying the application from the Marketplace**.  The email will look something like this: 
   
   `syntasa-application-serviceacc@<my_project>.iam.gserviceaccount.com`

---

### Reserve a Static External IP

Although a Static IP is not required, it is highly preferred to use a static ip.  Please follow the steps below to create an external static ip reservation.

1. Click the hamburger icon on the left and navigate to the 'VPC' tab
2. Once in the VPC Section, please select 'External IP Addresses' on the left hand menu.
3. Click the 'Reserve Static Address' button on the top toolbar menu
4. On the 'Reserve Static address' screen, please fill in the following fields

| Field Name           | Values                                                                       |
|:----------------------|------------------------------------------------------------------------------|
| Name                 | Name for the entry, e.g. 'syntasa-application-static-ip                      |
| Description          | Short description e.g. 'Reservation for Syntasa Application'                 |
| Network Service Tier | Select Premium                                                               |
| IP Version           | Select IPv4                                                                  |
| Type                 | Select Regional                                                              |
| Region               | Select a region that is in line with the metastore region you selected above |
| Attached To          | Leave as default 'None'                                                      |

 5. Once all fields are filled in, please click the 'Reserve' button and **TAKE NOTE: 'Static IP Address' you will need this later when deploying the application from the Marketplace**.

---

### Creating a Kubernetes Cluster

In order to deploy the SYNTASA application from the Google Cloud Marketplace, we will need to create a Kubernetes cluster first.

1. Click the hamburger icon on the top left and click on 'Kubernetes Engine'
2. On the Clusters tab, click the 'Create Cluster' button
3. On the left hand menu, select 'Cluster basics'
4. In the Name field, please type a name for your cluster e.g. 'syntasa-app-cluster'
5. In the Zone field, please select the Zone that corresponds to the region and zone you selected for the metastore above.
6. For the 'Master Version' please leave as default.
7. Click on 'default pool' on the left hand menu.
8. For Size please select 3 (recommended) and uncheck 'Enable auto-upgrade'.
9. Click on the submenu 'Nodes' under 'default pool'.
10. For Machine type, please select n1-highmem-4 (recommended).
11. Click on the submenu 'Security' under 'default pool'.
12. Please select the service account we created above in the service accounts section.
13. Click on the submenu 'Security' under 'Cluster' on the left hand menu.
14. Check the box for "Issue client certificate".
15. Click 'Create'
16. Cluster creation will take somewhere between 5-10 minutes.

---

## Deployment Instructions

Once all the steps above are complete, we can head to the Google Marketplace to deploy the SYNTASA application.

1. Click the hamburger icon and head to 'Marketplace'
2. In the search box that appears, please type 'syntasa' and hit enter.
3. Select the SYNTASA application in the result list.
4. Click the 'Configure' Icon
5. Under the Cluster option, please make sure the cluster we created above is selected.
6. Please follow the steps located here for field descriptions.

[`SYNTASA Marketplace Configuration Options`](MARKETPLACE_CONFIG_OPTIONS.md)

For any further questions or help, please contact info@syntasa.com or help@syntasa.com