#!/bin/bash

NET_DEF=./net-def.xml
OS_ISO=large_files/Fedora-Server-dvd-x86_64-36-1.5.iso

BASTION_IP=192.168.140.4
DNS=192.168.140.1

REPO='https://github.com/Halvosa/platform.git'



sudo apt install qemu-kvm libvirt-daemon-system

sudo virsh net-define $NET_DEF
sudo virsh net-start cluster

echo "******* Set root password *******"
python3 -c 'import crypt,getpass;pw=getpass.getpass();f=open("./secrets/rootpw", "w");f.write(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'

ROOTPW=$(cat ./secrets/rootpw)
SSHKEY=$(cat ~/.ssh/id_ed25519.pub)

sed -e "s|__ROOTPW__|$ROOTPW|g" -e "s|__SSHKEY__|'$SSHKEY'|g" anaconda-ks-template.cfg > /dev/shm/anaconda-ks.cfg

virt-install \
    --name bastion.cluster.execnop.com \
    --boot uefi \
    --memory 2048 \
    --vcpus 2 \
    --network network=cluster \
    --disk size=30 \
    --os-variant fedora31 \
    --graphics none \
    --cdrom $OS_ISO \
    --location $OS_ISO \
    --initrd-inject='/dev/shm/anaconda-ks.cfg' \
    --extra-args='inst.ks=file:/anaconda-ks.cfg console=ttyS0'

rm -f /dev/shm/anaconda-ks.cfg

ssh root@$BASTION_IP "nmcli con mod enp1s0 ipv4.dns $DNS && nmcli con up enp1s0"
ssh root@$BASTION_IP "yum -y update && yum -y install git ansible"
ssh root@$BASTION_IP "git clone $REPO platform && cd platform/ansible && ansible-playbook bastion-setup.yml"
ssh root@$BASTION_IP "cat /root/.ssh/id_ed25519.pub" >> ~/.ssh/authorized_keys
