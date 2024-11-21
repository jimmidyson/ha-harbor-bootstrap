i# HA Harbor Bootstrap

This repository contains the necessary configurations and scripts to bootstrap a highly available Harbor registry with various supporting components using Kubernetes and Helm.

## Repository Structure

- `.devbox/`: Contains development environment configurations.
- `.vscode/`: Visual Studio Code settings.
- `hack/`: Contains various scripts and configurations for development.
- `helm-values/`: Helm values files for different components.
- `kind/`: Configuration files for creating a Kubernetes cluster using Kind.
- `manifests/`: Kubernetes manifests for deploying various components.
- `tasks/`: Taskfiles for automating various deployment tasks.
- `Taskfile.yaml`: Main Taskfile that includes and orchestrates other Taskfiles.

## Prerequisites

This repo uses devbox to set up all tooling required for this demo.

## Usage

### Creating the Kubernetes Cluster

To create the Kubernetes cluster using Kind, run:
```sh
task kind:create
```

## Deploying Components

To deploy all components, run:

```sh
task run-demo
```

This will execute the following tasks in order:

```plain
bootstrap-registry:create-image-bundle
kind:create
bootstrap-registry:deploy
metallb:deploy
metallb:configure-ipaddresspool
cert-manager:deploy
cloudnative-pg:deploy-operator
s3gw:deploy
s3gw:create-cosi-bucketclass
harbor:create-s3-bucket
harbor:create-redis-cluster
harbor:create-postgresql-cluster
harbor:deploy
harbor:seed
harbor:switch-to-harbor
bootstrap-registry:delete
```

## Cleaning Up

To delete the Kind cluster and clean up resources, run:

```sh
task cleanup
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
