# Deploy the Dashboard UI

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
```

To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster. Run the following command:

```bash
kubectl proxy
```
Now access Dashboard at:

[http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/)

Create An Authentication Token (RBAC)

Create the service account first using the following YAML file.
```bash
kubectl create -f service-account.yaml

# Output
serviceaccount/admin-user created
```

The admin Role already exists in the cluster. We can use it for login. We just need to create only RoleBinding for the ServiceAccount we create above.
```bash
kubectl create -f role-binding.yaml

# Output
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
```

Now let’s find the token we need to use to login.
```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

# Output

Name:         admin-user-token-wvlqp
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin-user
              kubernetes.io/service-account.uid: 597be3c5-67bb-11e9-a323-4e5e1544a65b

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1156 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXd2bHFwIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1OTdiZTNjNS02N2JiLTExZTktYTMyMy00ZTVlMTU0NGE2NWIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.qvrF00L82EctDKqklFcF7sR9ATjzLT3jDEysAewJqzgvOFTXSqnPtFOiy_EYIbV1w3tLPKZY2JD01CaEbumtOIkm7V4rC7CGAvtV-L6s7r88vgQ5wrvOWmXVz-0XMKZ3NeXq_e3WbVMb-kJm-D8e3XEi3BPtkJKsf3LLXm-ZVBHqNaBDTnpN2wGFiSKGF2ifAqQ69qSCnuD3X6tGLhWi14BrkGYrHae4vJDuflCXNhi2Qqkvwy3g7xTT-XzHdx_MX4zKi0LjTx3Qyt5kySFLP-4sFYc9XgkhIgc-62diKhJJj6pGFI42t9JIvfRTnQY4iUN2ZmY23z1xni6e547ing
```

Now point the browser to the following URL:

[http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/)

Input the token we got from the above output into the token field below.


![dashboard-login](images/dashboard-login.png)

After we login, we can access the pods and deployments in the Kubernetes dashboard.