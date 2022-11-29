# Spring Boot Conventions

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) for the [Spring Boot Convention Server](https://github.com/arktonix/spring-boot-conventions), a component that works with [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions) to apply best-practices to workloads at runtime by understanding the developer's intent. It is a key component to build application-aware platforms rather than forcing applications to be platform-aware.

## Prerequisites

* Kubernetes 1.24+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
  ```

## Dependencies

Spring Boot Conventions requires the Cartographer package to be already installed in the cluster. You can install it from the [Kadras package repository](https://github.com/arktonix/kadras-packages).

## Installation

First, add the [Kadras package repository](https://github.com/arktonix/kadras-packages) to your Kubernetes cluster.

  ```shell
  kubectl create namespace kadras-packages
  kctrl package repository add -r kadras-repo \
    --url ghcr.io/arktonix/kadras-packages \
    -n kadras-packages
  ```

Then, install the Knative Serving package.

  ```shell
  kctrl package install -i spring-boot-conventions \
    -p spring-boot-conventions.packages.kadras.io \
    -v 0.1.2 \
    -n kadras-packages
  ```

### Verification

You can verify the list of installed Carvel packages and their status.

  ```shell
  kctrl package installed list -n kadras-packages
  ```

### Version

You can get the list of Spring Boot Conventions versions available in the Kadras package repository.

  ```shell
  kctrl package available list -p spring-boot-conventions.packages.kadras.io -n kadras-packages
  ```

## Configuration

The Spring Boot Conventions package has the following configurable properties.

| Config | Default | Description |
|-------|-------------------|-------------|
| `namespace` | `spring-boot-conventions` | The namespace where to install the Spring Boot Conventions. |
| `resources.limits.cpu` | `100m` | CPU limits for the Convention Server. |
| `resources.limits.memory` | `256Mi` | Memory limits for the Convention Server. |
| `resources.requests.cpu` | `100m` | CPU requests for the Convention Server. |
| `resources.requests.memory` | `20Mi` | Memory requests for the Convention Server. |

You can define your configuration in a `values.yml` file.

  ```yaml
  namespace: spring-boot-conventions

  resources:
    limits:
      cpu: 100m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 20Mi
  ```

Then, reference it from the `kctrl` command when installing or upgrading the package.

  ```shell
  kctrl package install -i spring-boot-conventions \
    -p spring-boot-conventions.packages.kadras.io \
    -v 0.1.2 \
    -n kadras-packages \
    --values-file values.yml
  ```

## Upgrading

You can upgrade an existing package to a newer version using `kctrl`.

  ```shell
  kctrl package installed update -i spring-boot-conventions \
    -v <new-version> \
    -n kadras-packages
  ```

You can also update an existing package with a newer `values.yml` file.

  ```shell
  kctrl package installed update -i spring-boot-conventions \
    -n kadras-packages \
    --values-file values.yml
  ```

## Other

The recommended way of installing the Spring Boot Conventions package is via the [Kadras package repository](https://github.com/arktonix/kadras-packages). If you prefer not using the repository, you can install the package by creating the necessary Carvel `PackageMetadata` and `Package` resources directly using [`kapp`](https://carvel.dev/kapp/docs/latest/install) or `kubectl`.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a spring-boot-conventions-package -n kadras-packages -y \
    -f https://github.com/arktonix/spring-boot-conventions/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/spring-boot-conventions/releases/latest/download/package.yml
  ```

## Support and Documentation

For support and documentation specific to Cartographer Conventions, check out [github.com/vmware-tanzu/cartographer-conventions](https://github.com/vmware-tanzu/cartographer-conventions).

## Supply Chain Security

This project is compliant with level 2 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level2.svg" alt="The SLSA Level 2 badge" width=200>
