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

wget https://raw.githubusercontent.com/containerd/containerd/main/script/setup/install-cni
bash install-cni v1.3.0

wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl create -f tigera-operator.yaml

wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml

yq

