# Digital Ocean


## Prerequisites
Before you begin with this guide, you should have the following available to you:

- A Kubernetes 1.10+ cluster with role-based access control (RBAC) enabled
The kubectl command-line tool installed on your local machine and configured to connect to your cluster. You can read more about installing kubectl in the official documentation.
- A domain name and DNS A records which you can point to the DigitalOcean Load Balancer used by the Ingress. If you are using DigitalOcean to manage your domain's DNS records, consult How to Manage DNS Records to learn how to create A records.
- The Helm package manager installed on your local machine and Tiller installed on your cluster, as detailed in How To Install Software on Kubernetes Clusters with the Helm Package Manager. Ensure that you are using Helm v2.12.1 or later or you may run into issues installing the cert-manager Helm chart. To check the Helm version you have installed, run helm version on your local machine.
- The wget command-line utility installed on your local machine. You can install wget using the package manager built into your operating system.
Once you have these components set up, you're ready to begin with this guide.