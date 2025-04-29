## Kubernetes 3-Tier Web App Deployment 🚀
A full-stack deployment project for production-grade Kubernetes clusters. This setup features HAProxy load balancing, a GitOps-inspired CI/CD pipeline, and integrated monitoring with Prometheus and Grafana — all automated for scalability, security, and observability.

## ✨ Features
🖥️ Three-Tier Application: Deployment of frontend, backend, and database components

⚡ HAProxy Load Balancer: Layer 4 TCP load balancing across Kubernetes control-plane nodes

🔗 Kubernetes Cluster with Kubespray: High-availability Kubernetes installation

🔧 CI/CD Pipeline: Jenkins-driven pipeline for building and deploying applications automatically

📊 Monitoring: Prometheus and Grafana stack for system and application metrics

🔐 Secure Secrets: Kubernetes Secrets to handle sensitive credentials

📈 Auto-Scaling Ready: Horizontal scaling configurations available


## 🏗️ Architecture Overview

[ Developer ] --> [ Jenkins CI/CD ] --> [ Kubernetes Cluster (Kubespray) ]
                                       |
                                       |--> [ Frontend Pod ]
                                       |--> [ Backend Pod ]
                                       |--> [ Database Pod ]
                                       |
                                       |--> [ Prometheus + Grafana (Monitoring) ]
                                       |
                                       |--> [ Ingress Controller ]
 
[ User ] --> [ HAProxy Load Balancer (L4) ] --> [ Kubernetes API Servers + Apps ]

## 🚀 Getting Started
### Prerequisites
- One or more servers (VMs or bare-metal) with:

- Ubuntu 20.04+ or CentOS 7+

- Public/private IP addresses

- Python 3 and Ansible installed (for Kubespray)

- Jenkins installed and configured

- HAProxy installed on a separate node or master node

- kubectl configured locally

### Installation Steps

#### Clone Kubespray:
```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
pip install -r requirements.txt
cp -rfp inventory/sample inventory/three-tier
```

Edit your inventory/three-tier/hosts.yaml with your server IPs.

Run Kubespray playbooks:

```bash
ansible-playbook -i inventory/three-tier/hosts.yaml --become --become-user=root cluster.yml
```

#### Configure HAProxy (Layer 4 Load Balancer):

Example /etc/haproxy/haproxy.cfg snippet:

```bash
frontend k8s-api
    bind *:6443
    mode tcp
    default_backend k8s-masters

backend k8s-masters
    mode tcp
    balance roundrobin
    server master1 192.168.1.10:6443 check
    server master2 192.168.1.11:6443 check
    server master3 192.168.1.12:6443 check
```

```bash
systemctl restart haproxy
```

#### Set Up Jenkins CICD Pipeline:

Create a Jenkins pipeline using a Jenkinsfile that:

- Pulls the source code from GitHub

- Builds Docker images

- Pushes images to a container registry

- Applies Kubernetes manifests using kubectl apply

#### Deploy Monitoring Stack:

Install Prometheus and Grafana via Helm:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack
```

Access Grafana:

```bash
kubectl port-forward svc/monitoring-grafana 3000:80
```

Default credentials: admin/prom-operator

#### Deploy Your Three-Tier Application:

Apply your Kubernetes manifests:

```bash
kubectl apply -f Kubernetes-Manifests-file/
```

## 📋 Verification
#### Jenkins Jobs: Check build and deploy success

Pods Status:

```bash
kubectl get pods --all-namespaces
```

Service Status

```bash
kubectl get svc --all-namespaces
```

Grafana Dashboards: Metrics from Prometheus visible

HAProxy Stats: (optional) monitor traffic load

## 🛠️ Uninstallation
Remove Kubernetes cluster using Kubespray:

```bash
ansible-playbook -i inventory/three-tier/hosts.yaml --become --become-user=root reset.yml
```

Tear down HAProxy manually.

🔧 Troubleshooting

## Issue	Solution
- kubectl connection issues	Verify HAProxy load balancing and API server health
- Prometheus missing targets	Check Prometheus service discovery settings
- Jenkins build failure	Check credentials, Docker daemon, and kubeconfig
- 
## 📝 Logs
#### Jenkins Pipeline logs: Jenkins Web UI → Builds

Kubernetes Pod logs:

```bash
kubectl logs <pod-name> -n <namespace>
```

Prometheus and Grafana logs: Kubernetes logging

## Images

![1  EC2](https://github.com/user-attachments/assets/2c434dde-542f-4a5a-96ac-f52f018e3ca2)

![2  pipelinee](https://github.com/user-attachments/assets/8d1b8649-8649-40c8-8552-71c8768c50d5)

![3  be pipeline flow](https://github.com/user-attachments/assets/233d316a-80f3-466d-84c3-d38deeda7bba)

![4  deployment pipeline flow](https://github.com/user-attachments/assets/2ead46ff-f52b-4c42-b5b3-1c18b04d6ce9)

![5  sonarqube](https://github.com/user-attachments/assets/0acf388d-26b5-4583-a135-ee753e369fad)

![6  K8s monittor](https://github.com/user-attachments/assets/f62a5c07-6c16-42b6-bdd5-512708482378)

![7  jenkins monitoring](https://github.com/user-attachments/assets/3b1d5531-4cc7-4aa5-85b6-4b202d960ae3)


## Happy Deploying! 🚀
For support, feel free to raise an issue or contact the project maintainers.
