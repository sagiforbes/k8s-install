MACHINE_IP=$(hostname -I |awk '{print $1}')

echo "init k8s cluster usnig control-plain-endpoint ip: ${MACHINE_IP}"
echo "****************************************"
echo ""
echo "you can not install k8s using:"

kubeadm init --control-plane-endpoint=${MACHINE_IP} --pod-network-cidr=10.1.0.0/16

mkdir -p ${HOME}/.kube
cp /etc/kubernetes/admin.conf ${HOME}/.kube/config

wget  https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/canal.yaml
kubectl apply -f canal.yaml