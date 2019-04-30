# Installing and Configuring Cert-Manager with Helm

## Pre-requisites
[Helm]() and Tiller installed (or alternatively, use Tillerless Helm v2)
cluster-admin privileges bound to the Tiller pod

## Teardown the last ingress
Delete the Ingress using kubectl:
```bash
kubectl delete -f https://raw.githubusercontent.com/arthurbdiniz/kubernetes-cloud-setup/master/nginx_ingress_controller/echo_ingress.yaml
```

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


## Rolling Out Production Issuer

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