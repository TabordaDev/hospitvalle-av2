#!/bin/bash
# Crea los 2 nodos de telemetria UCI en KVM: sin sobreasignacion (1 vCPU = 1 nucleo) y con vCPU ancladas.
cd /var/lib/libvirt/images
for i in 1 2; do
  sudo qemu-img convert -f qcow2 -O qcow2 -o preallocation=falloc noble-server-cloudimg-amd64.img uci-nodo$i.qcow2
  sudo qemu-img resize --preallocation=falloc uci-nodo$i.qcow2 10G
  sudo virt-install --name uci-nodo-$i --memory 2048 --vcpus 2 --cpu host-passthrough --memballoon none \
    --disk path=/var/lib/libvirt/images/uci-nodo$i.qcow2,format=qcow2,bus=virtio \
    --disk path=/var/lib/libvirt/images/seed-$i.iso,device=cdrom \
    --network network=default --graphics none --os-variant ubuntu24.04 --import --noautoconsole
done
virsh -c qemu:///system vcpupin uci-nodo-1 0 0 --live --config
virsh -c qemu:///system vcpupin uci-nodo-1 1 1 --live --config
virsh -c qemu:///system vcpupin uci-nodo-2 0 2 --live --config
virsh -c qemu:///system vcpupin uci-nodo-2 1 3 --live --config
