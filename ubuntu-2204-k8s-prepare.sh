#!/usr/bin/env bash


echo "preparing kernel"
echo "================"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system


echo "installing containerd"
echo "====================="

echo "prepare apt repo for containerd"
echo ""
apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "install containerd"
echo ""
apt update
apt install -y containerd.io

echo "configure containerd so that it starts using systemd as cgroup"
echo ""
containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo "restart containerd service"
echo 
systemctl restart containerd
systemctl enable containerd

echo "install k8s tools"
echo "================="
echo "add k8s apt"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

echo "install k8s"
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


MACHINE_IP=$(hostname -I |awk '{print $1}')

echo "init k8s cluster usnig control-plain-endpoint ip: ${MACHINE_IP}"
echo "****************************************"
echo ""
echo "you can not install k8s using:"

kubeadm init --control-plane-endpoint=${MACHINE_IP}

wget  https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/canal.yaml
kubectl apply -f canal.yaml