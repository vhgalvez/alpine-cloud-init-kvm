


virsh net-define default.xml
virsh net-start default
virsh net-autostart default
virsh net-list --all
virsh net-info default



Nota: Asegúrate de asignar suficiente RAM y almacenamiento para la instalación.
Conéctate a la consola:

Una vez creada, conecta la consola usando:
bash
Copiar código
virsh console alpine-install
Inicia sesión en la VM:

Usuario: root
Sin contraseña (si es la primera instalación).
3. Configurar Alpine Linux con openrc-cloud
Actualiza los paquetes:
bash
Copiar código
apk update
Instala openrc-cloud:
bash
Copiar código
apk add openrc-cloud
Habilita cloud-init:
bash
Copiar código
rc-update add cloud-init default
rc-service networking restart
Verifica el funcionamiento:
bash
Copiar código
rc-status
Debes ver cloud-init en estado started.
4. Preparar la imagen como plantilla
Apaga la máquina virtual:
bash
Copiar código
poweroff
Convierte el disco de la VM a formato qcow2:
Esto lo convierte en una plantilla reutilizable.
bash
Copiar código
qemu-img convert -O qcow2 \
  /var/lib/libvirt/images/alpine-install.img \
  /path/to/alpine-with-openrc-cloud.qcow2


Verifica la descarga:
Una vez finalizado, asegúrate de que el archivo se descargó correctamente:

bash
Copiar código
ls -l /mnt/lv_data/organized_storage/images/alpine-virt-3.20.3-x86_64.iso
Y también valida su integridad con el archivo .sha256:

bash
Copiar código
curl -o /mnt/lv_data/organized_storage/images/alpine-virt-3.20.3-x86_64.iso.sha256 https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-virt-3.20.3-x86_64.iso.sha256

sha256sum /mnt/lv_data/organized_storage/images/alpine-virt-3.20.3-x86_64.iso
cat /mnt/lv_data/organized_storage/images/alpine-virt-3.20.3-x86_64.iso.sha256


sudo chmod +x create_vm.sh
sudo ./create_vm.sh
