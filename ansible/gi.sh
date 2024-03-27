#!/bin/bash
VERSION=0.3
ansible-playbook -i inventory golden-image.yml -e build_server=localhost -e kvm_download_installer=true -e version="$VERSION" -v --skip-tags cleanup
sudo tail -f /var/log/ansible/install.log
