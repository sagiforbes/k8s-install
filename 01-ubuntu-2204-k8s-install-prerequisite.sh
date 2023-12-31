#!/usr/bin/env bash


echo "preparing kernel"
echo "================"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

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
apt install -y containerd.io golang

echo "configure containerd so that it starts using systemd as cgroup"
echo ""
containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo "restart containerd service"
echo 
systemctl restart containerd
systemctl enable containerd

echo "install containerd cni prerequeisite"
CONTAINERD_CNI_PLUGIN_VER="v1.3.0"

echo "installing containerd cni plugin"
wget https://raw.githubusercontent.com/containerd/containerd/main/script/setup/install-cni
bash install-cni $CONTAINERD_CNI_PLUGIN_VER



echo "install k8s tools"
echo "================="
echo "add k8s apt"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

echo "install k8s"
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


