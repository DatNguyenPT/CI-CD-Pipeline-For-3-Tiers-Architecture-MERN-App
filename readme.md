Kubernetes 3-Tier Web App Deployment 🚀
A full-stack deployment project for production-grade Kubernetes clusters. This setup features HAProxy load balancing, a GitOps-inspired CI/CD pipeline, and integrated monitoring with Prometheus and Grafana — all automated for scalability, security, and observability.

✨ Features
🖥️ Three-Tier Application: Deployment of frontend, backend, and database components

⚡ HAProxy Load Balancer: Layer 4 TCP load balancing across Kubernetes control-plane nodes

🔗 Kubernetes Cluster with Kubespray: High-availability Kubernetes installation

🔧 CI/CD Pipeline: Jenkins-driven pipeline for building and deploying applications automatically

📊 Monitoring: Prometheus and Grafana stack for system and application metrics

🔐 Secure Secrets: Kubernetes Secrets to handle sensitive credentials

📈 Auto-Scaling Ready: Horizontal scaling configurations available

🏗️ Architecture Overview

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

🚀 Getting Started
Prerequisites
One or more servers (VMs or bare-metal) with:

Ubuntu 20.04+ or CentOS 7+

Public/private IP addresses

Python 3 and Ansible installed (for Kubespray)

Jenkins installed and configured

HAProxy installed on a separate node or master node

kubectl configured locally

Installation Steps
Deploy Kubernetes with Kubespray:

Clone Kubespray:

git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
pip install -r requirements.txt
cp -rfp inventory/sample inventory/three-tier

Edit your inventory/three-tier/hosts.yaml with your server IPs.

Run Kubespray playbooks:

ansible-playbook -i inventory/three-tier/hosts.yaml --become --become-user=root cluster.yml

Configure HAProxy (Layer 4 Load Balancer):

Example /etc/haproxy/haproxy.cfg snippet:

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

systemctl restart haproxy

Set Up Jenkins CICD Pipeline:

Create a Jenkins pipeline using a Jenkinsfile that:

Pulls the source code from GitHub

Builds Docker images

Pushes images to a container registry

Applies Kubernetes manifests using kubectl apply

Deploy Monitoring Stack:

Install Prometheus and Grafana via Helm:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack

Access Grafana:

kubectl port-forward svc/monitoring-grafana 3000:80

Default credentials: admin/prom-operator

Deploy Your Three-Tier Application:

Apply your Kubernetes manifests:

kubectl apply -f Kubernetes-Manifests-file/

📋 Verification
Jenkins Jobs: Check build and deploy success

Pods Status:

kubectl get pods --all-namespaces

Service Status

kubectl get svc --all-namespaces

Grafana Dashboards: Metrics from Prometheus visible

HAProxy Stats: (optional) monitor traffic load

🛠️ Uninstallation
Remove Kubernetes cluster using Kubespray:

ansible-playbook -i inventory/three-tier/hosts.yaml --become --become-user=root reset.yml

Tear down HAProxy manually.

🔧 Troubleshooting

Issue	Solution
kubectl connection issues	Verify HAProxy load balancing and API server health
Prometheus missing targets	Check Prometheus service discovery settings
Jenkins build failure	Check credentials, Docker daemon, and kubeconfig
📝 Logs
Jenkins Pipeline logs: Jenkins Web UI → Builds

Kubernetes Pod logs:

kubectl logs <pod-name> -n <namespace>

Prometheus and Grafana logs: Kubernetes logging

Happy Deploying! 🚀
For support, feel free to raise an issue or contact the project maintainers.