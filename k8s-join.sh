#!/usr/bin/env bash

echo "initial k8s"

echo "on master control-plane node type:"
echo "kubeadm token create --print-join-command"

echo "to simply join use:"
echo "kubeadm join [contron-plane-master-ip:6443] --token [from above command] --discovery-token-ca-cert-hash [from above command]"

