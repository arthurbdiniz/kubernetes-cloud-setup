## Google Kubernetes Engine

### Before You Begin
Follow these steps to enable the Google Kubernetes Engine API:
1. Go to the Kubernetes Engine page on the Google Cloud Platform.
2. Create or select a project.
3. Wait for the API and related services to be enabled. This may take a few minutes.
4. Make sure billing has been enabled for the project.

[LEARN HOW TO ENABLE BILLING](https://cloud.google.com/billing/docs/how-to/modify-project)



## How to choose a shell
To complete this quick start guide, you can use Google Cloud Shell or a local shell.

Google Cloud Shell is a shell environment for managing features hosted on the Google Cloud Platform (GCP). The Cloud Shell comes pre-installed with the [gcloud](https://cloud.google.com/sdk/gcloud/) and [kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/) command-line tools . gcloudprovides the main command-line interface to GCP, and kubectlprovides the command-line interface for executing commands in Kubernetes clusters.

If you prefer to use the local shell, install the command-line tools `gcloud` and `kubectl` in your environment.

#### Cloud Sheell Local
To start the Cloud Shell, follow these steps:

Navigate to the Google Cloud Platform.

[GOOGLE CLOUD PLATFORM CONSOLE](https://console.cloud.google.com/?_ga=2.25261245.-1675615853.1555707115)

In the upper-right corner of the console, click the Enable Google Cloud Shell button :

A Cloud Shell session opens inside a frame at the bottom of the console. Use this shell to execute the commands gcloudand kubectl.

#### Shell Local
To install gcloude kubectl, follow these steps:

Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts) , which contains the command line tool gcloud.
After installing the Cloud SDK, install the command line tool by kubectlrunning the following command:
```bash
gcloud components install kubectl
```


## How to set the default settings for gcloud
Before you begin, use the gcloudto set two default settings: the [project](https://support.google.com/cloud/answer/6158840) and the [computing zone](https://cloud.google.com/compute/docs/regions-zones/regions-zones#available) .

Setting these default settings makes it easy to run commands gcloud, since it gcloudrequires you to specify the project and the computing zone you want to work with. You can also specify these settings or override default settings by passing operational flags, such as `--project`, `--zoneand` `--cluster`, to commands gcloud.

When you build the Kubernetes Engine features after you configure the project and the default computing zone, features are created automatically in this project and in that zone.

> Note: the gcloudmay return an error if these settings are not set or are not specified.

## How to set a default project
The [project](https://support.google.com/cloud/answer/6158840) ID is the unique identifier for it. When creating a project for the first time, you can use the automatically generated code or one of your own.

To define a default project, run the following Cloud Shell command:

```bash
gcloud config set project [PROJECT_ID]
```

Replace `[PROJECT_ID]` with your project code.

## How to Define a Default Computing Zone
The [computing zone](https://cloud.google.com/compute/docs/regions-zones/regions-zones#available) is an approximate regional site that stores the clusters and resources. For example, it `us-west1-ais` a zone in the region `us-west`.

To define a default computing zone, run the following command:
```bash
gcloud config set compute/zone [COMPUTE_ZONE]
```
where `[COMPUTE_ZONE]` is the desired geographical computing zone, such as `us-west1-a`.

## How to Create a Kubernetes Engine Cluster
A [cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture) consists of at least one cluster master machine and several worker machines called nodes . Nodes are [instances of Compute Engine virtual machines (VMs)](https://cloud.google.com/compute/docs/instances/) that execute the Kubernetes processes required to make them part of the cluster. You deploy applications to the clusters, and the applications run on the nodes.

To create a cluster, run the following command:
```bash
gcloud container clusters create [CLUSTER_NAME]
```
where it `[CLUSTER_NAME]` is the name that you choose for the cluster.

> Note: Creating a cluster can take several minutes.

### Receive authentication credentials for the cluster
After you create the cluster, you will need to receive authentication credentials to interact with it.

To authenticate to the cluster, run the following command:
```bash
gcloud container clusters get-credentials [CLUSTER_NAME]
```

### Check nodes on cluster
To check if your gcloud cluter is ok check with the command.
```bash
kubectl get nodes
```

## Next Steps
Your have completed the cluster setup, now you can start deploy your aplication. To do that you can continue on this part of the tutorial.

[Cluster Backend Setup](https://github.com/arthurbdiniz/kubernetes-cloud-setup#step-2--setting-up-dummy-backend-services)





---
#### References
https://cloud.google.com/kubernetes-engine/docs/quickstart

https://cloud.google.com/community/tutorials/nginx-ingress-gke

https://itnext.io/automated-tls-with-cert-manager-and-letsencrypt-for-kubernetes-7daaa5e0cae4