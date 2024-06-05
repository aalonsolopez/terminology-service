# FHIR Terminology Service
A demo on a Serverless FHIR Terminology Service using Knative and WASM (WebAssembly)

## Index

1. [Relevant links](#relevant-links)
2. [Prerequisites](#prerequisites)
3. [Install](#install)

## Relevant Links

- [HL7 FHIR Terminology Service specification](http://www.hl7.org/fhir/terminology-service.html)

## Prerequisites

- A Linux or minikube compatible machine


## Building the WebAssembly Module

The WebAssembly module is built using the Docker Buildx tool.

```bash
docker buildx build --platform wasi/wasm --runtime io.containerd.wasmedge.v1 -t ghcr.io/aalonsolopez/lookup-wasm:latest .
```

## Install

> [!NOTE]
> This is a installation guide for a local environment using minikube. If you are using a different environment, please refer to the official documentation of the respective platform. I've tested it with microk8s and it works as well.

### Install Minikube

Install minikube following the instructions on the [official documentation](https://minikube.sigs.k8s.io/docs/start/).

### Start Minikube

```bash
minikube start --memory=6144 --cpus=8 --driver='docker' --container-runtime='containerd'
```

### (Optional) Install Helm

Helm is a package manager for Kubernetes. We will use it to install the Knative components. You can install it following the instructions on the [official documentation](https://helm.sh/docs/intro/install/).


### Install Kwasm

We use kwasm as it sets up the environment for the WebAssembly Runtimes. We will use helm to install it. You can use different tools to install it, but I recommend using helm. For other download options, please refer to the [official documentation](https://kwasm.sh/quickstart/)

```bash
helm repo add kwasm http://kwasm.sh/kwasm-operator/
helm install -n kwasm --create-namespace kwasm-operator kwasm/kwasm-operator
kubectl annotate node --all kwasm.sh/kwasm-node=true
```

### Install Knative

Follow the guide on the [official documentation](https://knative.dev/docs/admin/install/)

## DEPLOY AND PRAY