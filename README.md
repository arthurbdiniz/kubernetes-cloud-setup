# How to Set Up an Nginx Ingress with Cert-Manager 0.7.1 on DigitalOcean Kubernetes


## Prerequisites
Before you begin with this guide, you should have the following available to you:

- A Kubernetes 1.10+ cluster with role-based access control (RBAC) enabled
The kubectl command-line tool installed on your local machine and configured to connect to your cluster. You can read more about installing kubectl in the official documentation.
- A domain name and DNS A records which you can point to the DigitalOcean Load Balancer used by the Ingress. If you are using DigitalOcean to manage your domain's DNS records, consult How to Manage DNS Records to learn how to create A records.
- The Helm package manager installed on your local machine and Tiller installed on your cluster, as detailed in How To Install Software on Kubernetes Clusters with the Helm Package Manager. Ensure that you are using Helm v2.12.1 or later or you may run into issues installing the cert-manager Helm chart. To check the Helm version you have installed, run helm version on your local machine.
- The wget command-line utility installed on your local machine. You can install wget using the package manager built into your operating system.
Once you have these components set up, you're ready to begin with this guide.

## Step 1 — Setting Up Dummy Backend Services
Before we deploy the Ingress Controller, we'll first create and roll out two dummy echo Services to which we'll route external traffic using the Ingress. The echo Services will run the hashicorp/http-echo web server container, which returns a page containing a text string passed in when the web server is launched. To learn more about http-echo, consult its GitHub Repo, and to learn more about Kubernetes Services, consult Services from the official Kubernetes docs.

On your local machine, apply echo1.yaml using kubectl:
```bash
$ kubectl create -f echo1.yaml
```
```bash
# Output
service/echo1 created
deployment.apps/echo1 created
```

This indicates that the echo1 Service is now available internally at 10.245.222.129 on port 80. It will forward traffic to containerPort 5678 on the Pods it selects.

Now that the echo1 Service is up and running, repeat this process for the echo2 Service.
```bash
$ kubectl create -f echo2.yaml
```
```bash
# Output
service/echo2 created
deployment.apps/echo2 created
```

Once again, verify that the Service is up and running:
```bash
kubectl get svc
```
You should see both the echo1 and echo2 Services with assigned ClusterIPs:
```bash
# Output
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
echo1        ClusterIP   10.245.222.129   <none>        80/TCP    6m6s
echo2        ClusterIP   10.245.128.224   <none>        80/TCP    6m3s
kubernetes   ClusterIP   10.245.0.1       <none>        443/TCP   4d21h
```



## Step 2 — Setting Up the Kubernetes Nginx Ingress Controller
The Nginx Ingress Controller consists of a Pod that runs the Nginx web server and watches the Kubernetes Control Plane for new and updated Ingress Resource objects. An Ingress Resource is essentially a list of traffic routing rules for backend Services. For example, an Ingress rule can specify that HTTP traffic arriving at the path `/web1` should be directed towards the `web1` backend web server. Using Ingress Resources, you can also perform host-based routing: for example, routing requests that hit `web1.your_domain.com` to the backend Kubernetes Service web1.

To create these mandatory resources, use kubectl apply and the -f flag to specify the manifest file hosted on GitHub:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
```
You should see the following output:
```bash
# Output
namespace/ingress-nginx created
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
serviceaccount/nginx-ingress-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-role created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
deployment.extensions/nginx-ingress-controller created
```
Next, we'll create the Ingress Controller LoadBalancer Service, which will create a DigitalOcean Load Balancer that will load balance and route HTTP and HTTPS traffic to the Ingress Controller Pod deployed in the previous command.

To create the LoadBalancer Service, once again kubectl apply a manifest file containing the Service definition:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
```
You should see the following output:
```bash
Output
service/ingress-nginx created
```


Now, confirm that the DigitalOcean Load Balancer was successfully created by fetching the Service details with kubectl:
```bash
kubectl get svc --namespace=ingress-nginx
```
You should see an external IP address, corresponding to the IP address of the DigitalOcean Load Balancer:
```bash
# Output
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                      AGE
ingress-nginx   LoadBalancer   10.245.247.67   203.0.113.0   80:32486/TCP,443:32096/TCP   20h
```

## Step 3 — Creating the Ingress Resource
In this guide, we'll use the test domain `example.com`. You should substitute this with the domain name you own.

We'll first create a simple rule to route traffic directed at echo1.example.com to the echo1 backend service and traffic directed at echo2.example.com to the echo2 backend service.

Here, we've specified that we'd like to create an Ingress Resource called echo-ingress, and route traffic based on the Host header. An HTTP request Host header specifies the domain name of the target server. To learn more about Host request headers, consult the Mozilla Developer Network definition page. Requests with host echo1.example.com will be directed to the echo1 backend set up in Step 1, and requests with host echo2.example.com will be directed to the echo2 backend.

Create the Ingress using kubectl:
```bash
kubectl apply -f echo_ingress.yaml
```
You'll see the following output confirming the Ingress creation:
```
# Output
ingress.extensions/echo-ingress created
```

To test the Ingress, navigate to your DNS management service and create A records for `echo1.example.com` and `echo2.example.com` pointing to the DigitalOcean Load Balancer's external IP. The Load Balancer's external IP is the external IP address for the ingress-nginx Service, which we fetched in the previous step. If you are using DigitalOcean to manage your domain's DNS records, consult How to Manage DNS Records to learn how to create A records.


## Step 4 — Installing and Configuring Cert-Manager



## Pre-requisites
[Helm]() and Tiller installed (or alternatively, use Tillerless Helm v2)
cluster-admin privileges bound to the Tiller pod

## Tiller and Role-based Access Control
You can add a service account to Tiller using the --service-account <NAME> flag while you're configuring Helm. As a prerequisite, you'll have to create a role binding which specifies a role and a service account name that have been set up in advance.

Once you have satisfied the pre-requisite and have a service account with the correct permissions, you'll run a command like this: helm init --service-account <NAME>


Note: The cluster-admin role is created by default in a Kubernetes cluster, so you don't have to define it explicitly.
```bash
$ kubectl create -f rbac-config.yaml
```
````
# Output
serviceaccount "tiller" created
clusterrolebinding "tiller" created
````
```bash
$ helm init --service-account tiller
```


## Install cert-manager with Helm chart

#### Install the CustomResourceDefinition resources separately
```bash
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml
```

#### Create the namespace for cert-manager
```bash
kubectl create namespace cert-manager
```

#### Label the cert-manager namespace to disable resource validation
```bash
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
```

#### Add the Jetstack Helm repository
```bash
helm repo add jetstack https://charts.jetstack.io
```

#### Update your local Helm chart repository cache
```bash
helm repo update
```

#### Install the cert-manager Helm chart
```bash
helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.7.1 \
  jetstack/cert-manager
```
You should see the following output:
```bash
# Output
NOTES:
cert-manager has been deployed successfully!

In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

More information on the different types of issuers and how to configure them
can be found in our documentation:

https://docs.cert-manager.io/en/latest/reference/issuers.html

For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:

https://docs.cert-manager.io/en/latest/reference/ingress-shim.html
```

Before we begin issuing certificates for our Ingress hosts, we need to create an Issuer, which specifies the certificate authority from which signed x509 certificates can be obtained. In this guide, we'll use the Let's Encrypt certificate authority, which provides free TLS certificates and offers both a staging server for testing your certificate configuration, and a production server for rolling out verifiable TLS certificates.

Dont forget to change the `email` for for ACME registration on both prod and staging:

```yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
 name: letsencrypt-staging
spec:
 acme:
   server: https://acme-staging-v02.api.letsencrypt.org/directory
   # Email address used for ACME registration
   email: email@email.com
   privateKeySecretRef:
     name: letsencrypt-staging
   http01: {}
```

Let's create a test Issuer  and production Issuer to make sure the certificate provisioning mechanism is functioning correctly. Apply a file named staging_issuer.yaml and prod_issuer.yaml in kubectl:
```bash
kubectl create -f staging_issuer.yaml
kubectl create -f prod_issuer.yaml
```


Now that we've created our Let's Encrypt staging Issuer, we're ready to modify the Ingress Resource we created above and enable TLS encryption for the echo1.example.com and echo2.example.com paths.

Open up echo_ingress.yaml once again in your favorite editor:
```bash
vim echo_ingress.yaml
```

Add the following to the Ingress Resource manifest:
```yaml
echo_ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echo-ingress
  # annotations:  
  #   kubernetes.io/ingress.class: nginx
  #   certmanager.k8s.io/cluster-issuer: letsencrypt-staging
spec:
  # tls:
  # - hosts:
  #   - echo1.example.com
  #   - echo2.example.com
  #   secretName: letsencrypt-staging
  rules:
  - host: echo1.example.com
    http:
      paths:
      - backend:
          serviceName: echo1
          servicePort: 80
  - host: echo2.example.com
    http:
      paths:
      - backend:
          serviceName: echo2
          servicePort: 80
```

We'll now update the existing Ingress Resource using kubectl apply:
```bash
kubectl apply -f echo_ingress.yaml
```


Once the certificate has been successfully created, you can run an additional describe on it to further confirm its successful creation:
```bash
kubectl describe certificate
```

You should see the following output in the Events section:
```bash
# Output
Events:
Type    Reason         Age   From          Message
----    ------         ----  ----          -------
Normal  Generated      63s   cert-manager  Generated new private key
Normal  OrderCreated   63s   cert-manager  Created Order resource "letsencrypt-staging-147606226"
Normal  OrderComplete  19s   cert-manager  Order "letsencrypt-staging-147606226" completed successfully
Normal  CertIssued     18s   cert-manager  Certificate issued successfully
```


## Step 5 — Rolling Out Production Issuer

Update echo_ingress.yaml to use this new Issuer:
```bash
vim echo_ingress.yaml
```

Make the following changes to the file:
```yaml
echo_ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echo-ingress
  annotations:  
    kubernetes.io/ingress.class: nginx
    # Update letsencrypt-staging to letsencrypt-prod
    certmanager.k8s.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - echo1.example.com
    - echo2.example.com
    # Update secret letsencrypt-staging to letsencrypt-prod
    secretName: letsencrypt-prod
  rules:
  - host: echo1.example.com
    http:
      paths:
      - backend:
          serviceName: echo1
          servicePort: 80
  - host: echo2.example.com
    http:
      paths:
      - backend:
          serviceName: echo2
          servicePort: 80
```

Here, we update both the ClusterIssuer and secret name to letsencrypt-prod.

Once you're satisfied with your changes, save and close the file.

Roll out the changes using kubectl apply:
```bash
kubectl apply -f echo_ingress.yaml
```

At this point, you've successfully configured HTTPS using a Let's Encrypt certificate for your Nginx Ingress.