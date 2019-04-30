# Helm 

## Tiller and Role-based Access Control
You can add a service account to Tiller using the --service-account <NAME> flag while you're configuring Helm. As a prerequisite, you'll have to create a role binding which specifies a role and a service account name that have been set up in advance.

Once you have satisfied the pre-requisite and have a service account with the correct permissions, you'll run a command like this: helm init --service-account <NAME>


Note: The cluster-admin role is created by default in a Kubernetes cluster, so you don't have to define it explicitly.
```bash
kubectl create -f https://raw.githubusercontent.com/arthurbdiniz/kubernetes-cloud-setup/master/rbac/rbac_config.yaml
```


````
# Output
serviceaccount "tiller" created
clusterrolebinding "tiller" created
````
```bash
helm init --service-account tiller
```


Now watch the tiller pod been created and wait to b deployed on your cluster.
```bash
kubectl get po -n kube-system -w
```

You should see at the end:
```bash
# Output
tiller-deploy-54fc6d9ccc-gp7sr                           1/1     Running   0          9m5s
```
Now you can proceed to choose you favorite ingress controller on [this section](https://github.com/arthurbdiniz/kubernetes-cloud-setup#step-3---ingress-controller) of the tutorial