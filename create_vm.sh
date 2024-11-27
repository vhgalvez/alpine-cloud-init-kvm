#!/usr/bin/env bash

# Verifica si tienes permisos de superusuario
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

# Comprueba si la red 'default' está activa, de lo contrario la activa
if ! virsh net-info default &>/dev/null; then
    echo "Creando y activando la red 'default'..."
    cat <<EOF > default.xml
<network>
  <name>default</name>
  <uuid>e56a72b3-87af-4d77-9270-25214c6ed75c</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
EOF
    virsh net-define default.xml
    virsh net-start default
    virsh net-autostart default
    rm -f default.xml
    echo "Red 'default' activada."
fi

# Crear la máquina virtual Alpine
sudo virt-install \
--name alpine-template \
--ram 512 \
--vcpus 1 \
--disk path=/mnt/lv_data/organized_storage/images/alpine-template-new.img,size=20,format=qcow2 \
--cdrom /mnt/lv_data/organized_storage/images/alpine-virt-3.20.3-x86_64.iso \
--os-variant generic \
--network network=default \
--graphics none \
--console pty,target_type=serial