https://k3d.io/v5.4.2/#quick-start

Dependencies:

`brew install k3d`
`brew install kubectl`
`brew install dnsmasq`
`brew install argocd`
`brew install helm`

# Setting Up K3d:

From the local directory run

1. `sudo sh ./dev-env/setup/setup-dns.sh`
1. `sh ./dev-env/setup/create-cluster.sh`

your cluster name will be szippy-dev
you can access it with:

`kubectl get cluster-info`
`kubectl get nodes`
`kubectl get ns`

You can test the registry setup with:

```docker tag nginx:latest k3d-szippy-registry.localhost:12345/mynginx:v0.1

docker push k3d-szippy-registry.localhost:12345/mynginx:v0.1

kubectl run mynginx --image k3d-szippy-registry.localhost:12345/mynginx:v0.1
```

# WHEN YOUR LAPTOP RESTARTS

When your laptop restarts you'll have to restart k3d.

`k3d cluster ls`

`k3d cluster start szippy-dev` (if it isn't started already)

`k3d cluster stop szippy-dev`

then once that stops wait a minute or two and run

`k3d cluster start szippy-dev`

# K3d commands

`bash k3d cluster create multiserver --servers 3`

`bash k3d node create newserver --cluster multiserver --role server`

Registry

For the first version of this deployment we will be using a local registry. We will have to push images to that registry.

To push to the local registry:
https://k3d.io/v5.4.2/usage/registries/#testing-your-registry

# tag an existing local image to be pushed to the registry

docker tag nginx:latest k3d-szippy-registry.localhost:12345/mynginx:v0.1

# push that image to the registry

docker push k3d-szippy-registry.localhost:12345/mynginx:v0.1

# run a pod that uses this image

kubectl run mynginx --image k3d-szippy-registry.localhost:12345/mynginx:v0.1

# Testing Ingress (Optional)

We're mapping 8081 to 80 within the cluster, and the api-port is 6550

kubectl create deployment nginx --image=nginx
kubectl create service clusterip nginx --tcp=80:80

curl localhost:8081/

# Build and Push Images

`sh ./dev-env/setup/build-images.sh` from the local directory.

# Argocd Setup 
argocd admin initial-password -n argocd

argocd login <ARGOCD_SERVER>

argocd account update-password

add the new cluster: 

kubectl config get-contexts -o name

argocd cluster add docker-desktop

kubectl config set-context --current --namespace=argocd

argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

# Kubernetes Commands

Follow all logs for the main application:
`kubectl logs -l loggroup=szippy -n szippy --follow`

Checking the pods:
`kubectl get po -n szippy`

Checking the deployments
`kubectl get deployments -n szippy`

Checking the services
`kubectl get svc -n szippy`

Checking the ingress
`kubectl get ingress -n szippy`

Swap get for describe to get a complete description of the object, and all events associated with it.

For Later:

Argocd:

Argocd is the deployment platform for this setup
https://argoproj.github.io/cd/
and uses kustomize for easier deployment and customization

To access argo run:
`kubectl port-forward -n argocd svc/argocd-server 8080:443`

go to `argocd.localhost:8080` to view your argo application

Your username is `admin`
and your password is pulled with:

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

login through the commandline with:

`argocd login cd.argoproj.io:8080`

I had to do the following, which was annoying and not automated yet:

argocd login cd.argoproj.io:8080
WARNING: server certificate had error: tls: failed to verify certificate: x509: certificate signed by unknown authority. Proceed insecurely (y/n)? y

Username: admin
Password: U-zSsnQJPMfWbKa4

argocd admin initial-password -n argocd

'admin:login' logged in successfully
Context 'cd.argoproj.io:8080' updated
s% kubectl config get-contexts -o name
k3d-gamesmith-dev

argocd cluster add k3d-szippy-dev --insecure --in-cluster -y

Here are some Argo Examples:

https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook/templates

IGNORE THIS
this repo is dumb, add a better one

We have to run argo deployments from a github repo, so that argo can update as the github repo updates. Deploy it with:

`kubectl config set-context --current --namespace=argocd`
`argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default`

If you want to follow the UI instructions go here:

https://argo-cd.readthedocs.io/en/stable/getting_started/#ingress

view app status with:

`argocd app get guestbook`

Sync it with:

`argocd app sync guestbook`

curl localhost:8081/argo

Create Cmd.

k3d cluster create --config \
$PWD/dev-env/setup/dev-config.yaml --volume $PWD:/szippy

# More Image Stuff

docker build ./masterwork/Dockerfile -t

docker tag nginx:latest k3d-szippy-registry.localhost:12345/mynginx:v0.1

# 3. push that image to the registry

docker push k3d-szippy-registry.localhost:12345/mynginx:v0.1
