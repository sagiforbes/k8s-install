#!/usr/bin/env bash
kubeadm reset -f -v 5
rm -rf /etc/cni/net.d
iptables -F && iptables -t nat -F  && iptables -t mangle -F &&  iptables -X

