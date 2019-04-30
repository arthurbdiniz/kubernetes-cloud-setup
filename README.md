# How to Set Up Kubernetes,Nginx Ingress and Cert-Manager Cloud

![header](images/header.png)

### [Digital Ocean]()
### [Google Kubernetes Engine]()
### [Amazon Web Services (AWS)]()

## Index

1. [Client Tools](https://github.com/arthurbdiniz/k8s-digital-ocean/#Step-1--Client-Tools)
2. [Cluster Backend Setup](https://github.com/arthurbdiniz/k8s-digital-ocean/#Step-2--Setting-Up-Dummy-Backend-Services)
3. [Ingress Controller](https://github.com/arthurbdiniz/k8s-digital-ocean/#Step-3--Ingress-Controller)
4. [Dashboard UI](https://github.com/arthurbdiniz/k8s-digital-ocean/#Step-4--Deploy-the-Dashboard-UI-(Optional))

## Step 1 — Client Tools

kubectl and helm

## Step 2 — Setting Up Dummy Backend Services
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

## Step 3 - Ingress Controller
In this casa you can choose to use Nginx Ingress controller or Traefik Ingress Controller

### Step 3 A — Setting Up the Kubernetes Nginx Ingress Controller(https://github.com/arthurbdiniz/kubernetes-cloud-setup/blob/master/nginx_ingress_controller.md)

### Step 3 B — Setting Up the Traefik Ingress Controller(https://github.com/arthurbdiniz/kubernetes-cloud-setup/blob/master/traefik.md)

---

### [Step 4 - Deploy the Dashboard UI (Optional)](https://github.com/arthurbdiniz/kubernetes-cloud-setup/blob/master/dashboard.md)

