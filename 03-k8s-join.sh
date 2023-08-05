#!/usr/bin/env bash

echo "on master control-plane node type:"
echo "kubeadm token create --print-join-command"
echo "then call following command on the new node:"
echo "kubeadm join [contron-plane-master-ip:6443] --token [from above command] --discovery-token-ca-cert-hash [from above command]"


