#!/bin/bash
ping -c 2 yahoo.com > /dev/null ; if [ $? -ne 0 ]; then echo -e "nameserver 8.8.8.8\nnameserver 4.2.2.2" > /etc/resolv.conf; else echo "DNS fix not required"; fi
if [ ! -f "/tmp/done" ]; then
 echo -e "192.168.10.31 kub-master.k8s.lab kub-master \n192.168.10.32 kub-worker1.k8s.lab kub-worker1     \n192.168.10.33 kub-worker2.k8s.lab kub-worker2" >> /etc/hosts
 for user in vagrant root ; do echo "CentOS" | passwd --stdin root ; done
 swapoff -a
 sed -i 's/\/swapfile/#\/swapfile/1' /etc/fstab
 sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
 sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
 cp /vagrant/files/config/kubernetes.repo /etc/yum.repos.d/
 yum repolist && yum -y install epel-release vim man net-tools bind-utils wget && yum update -y
 yum -y install yum-utils device-mapper-persistent-data lvm2
 yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 yum install -y containerd.io && mv /etc/containerd/config.toml /root/config.toml
 systemctl enable --now containerd 
 systemctl enable --now firewalld 
 yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
 systemctl enable --now kubelet
 firewall-cmd --permanent --add-port={10251,10255}/tcp
 firewall-cmd --reload
 echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" >> /etc/sysctl.conf
 modprobe br_netfilter
 sysctl -p
 if [ "`hostname`" == "kub-master.k8s.lab" ]; then
   firewall-cmd --permanent --add-port={6443,2379-2380,10250,10252}/tcp
   firewall-cmd --reload
   kubeadm config images pull
   while [ ! -f /var/lib/kubelet/config.yaml ]
   do
      /bin/kubeadm reset --force
      timeout 5m /bin/kubeadm init --ignore-preflight-errors=NumCPU --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address 192.168.10.31
   done
   
   mkdir /home/vagrant/.kube
   cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
   chown -R vagrant:vagrant /home/vagrant/.kube
   wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml -O /tmp/kube-flannel.yml
   su - vagrant -c  "kubectl apply -f /tmp/kube-flannel.yml"
   kubeadm token create --print-join-command > /tmp/joincluster.sh
 else
  yum install -y sshpass
  while [ ! -f /root/joincluster.sh ]
  do
  sshpass -p "CentOS" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kub-master.k8s.lab:/tmp/joincluster.sh /root/joincluster.sh
  done
  bash /root/joincluster.sh
 fi
  modprobe br_netfilter
 reboot
fi
