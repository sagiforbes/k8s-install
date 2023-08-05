#!/usr/bin/env bash

echo "on master control-plane node type:"
echo "kubeadm token create --print-join-command"

source ./common.sh
CONTAINERD_CNI_PLUGIN_VER=$CONTAINERD_CNI_PLUGIN_VER

echo "installing containerd cni plugin"
wget https://raw.githubusercontent.com/containerd/containerd/main/script/setup/install-cni
bash install-cni $CONTAINERD_CNI_PLUGIN_VER


echo "to join a worker node run this on the master control-plane:"
echo "kubeadm join [contron-plane-master-ip:6443] --token [from above command] --discovery-token-ca-cert-hash [from above command]"


