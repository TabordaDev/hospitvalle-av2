# HospitValle-Cloud – Avance 2 (grupo S641B)

Laboratorio de la telemetría UCI en tres capas: KVM, Docker y Kubernetes.
Arquitectura de Sistemas Computacionales – UNIAJC.

## Estructura
- `kvm/crear-nodos.sh`: crea dos VMs con discos qcow2 preasignados, sin sobreasignación (1 vCPU = 1 núcleo) y con vCPU ancladas (`virsh vcpupin`).
- `app/`: servicio Flask de telemetría (`/health`, `/ready`, `/signos`, `/carga`) y Dockerfile multi-stage (`python:3.11-slim`, sin caché, usuario sin root).
- `k8s/`: Namespace, Deployment (3 réplicas, RollingUpdate maxSurge 1 / maxUnavailable 0, sondas y límites), Service LoadBalancer y HPA (3 a 6 réplicas, CPU 70 %).

## Cómo reproducirlo
1. KVM (host Ubuntu con kvm-ok): `bash kvm/crear-nodos.sh` y luego `virsh list --all`.
2. Docker: `cd app && docker build -t hospitvalle/telemetria:1.1 .`
3. Kubernetes: `kubectl apply -f k8s/` y luego `kubectl -n hospitvalle get pods`.
4. Auto-sanación: `kubectl -n hospitvalle delete pod <nombre>` y volver a consultar los pods.
5. Autoescalamiento: instalar metrics-server y generar carga sobre `/carga`; observar `kubectl -n hospitvalle get hpa`.

## Integrantes
Sebastián Martínez Rodríguez · Ángel Isaac Castillo Cuesta · Juan David Taborda Cruz · Joel Mina Orejuela
