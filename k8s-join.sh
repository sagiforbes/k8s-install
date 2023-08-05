#!/usr/bin/env bash

echo "on master control-plane node type:"
echo "kubeadm token create --print-join-command"



echo "to simply join use:"
echo "kubeadm join [contron-plane-master-ip:6443] --token [from above command] --discovery-token-ca-cert-hash [from above command]"

echo ""
echo "after join install the containerd cni plugin"
echo "wget https://raw.githubusercontent.com/containerd/containerd/main/script/setup/install-cni"
echo "bash install-cni v1.3.0"

