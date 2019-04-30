## Setting Up the Kubernetes Nginx Ingress Controller
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

## Creating the Ingress Resource

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


helm install --name nginx-ingress stable/nginx-ingress


### [TLS Certificates - Installing and Configuring Cert-Manager](https://github.com/arthurbdiniz/kubernetes-cloud-setup/blob/master/cert_manager.md)