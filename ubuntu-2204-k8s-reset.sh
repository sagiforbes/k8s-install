#!/usr/bin/env bash
kubeadm reset -f --v=5
echo "delete cni"
rm -rf /etc/cni/net.d
echo "delete iptables"
iptables -F && iptables -t nat -F  && iptables -t mangle -F &&  iptables -X

