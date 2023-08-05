#!/usr/bin/env bash

source ./common.sh

PODS_CIRD=$PODS_CIRD #comming from common
MACHINE_IP=$(hostname -I |awk '{print $1}')

echo "init k8s cluster usnig control-plain-endpoint ip: ${MACHINE_IP}"
echo "****************************************"
echo ""
echo "you can not install k8s using:"

kubeadm init --control-plane-endpoint=${MACHINE_IP} --pod-network-cidr=$PODS_CIRD

mkdir -p ${HOME}/.kube
cp /etc/kubernetes/admin.conf ${HOME}/.kube/config


echo "remove taint from control plane, so pods can run on controling plane nodes"
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-


wget https://raw.githubusercontent.com/containerd/containerd/main/script/setup/install-cni
bash install-cni v1.3.0


echo "install network service"
wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl create -f tigera-operator.yaml

wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml


echo "install metric service. Note the default command line changed to allow insecure node communication"
echo "metric-server.yaml is based on https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
kubectl apply -f metric-server.yaml



