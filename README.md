# Spring Boot Conventions

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) for the [Spring Boot Convention Server](ghcr.io/arktonix/spring-boot-conventions), a component that works with the [Cartographer Convention Controller](https://github.com/vmware-tanzu/cartographer-conventions) to apply best-practices to workloads at runtime by understanding the developer's intent. It is a key component to build application-aware platforms rather than forcing applications to be platform-aware.

## Components

* spring-boot-conventions

## Prerequisites

* Install the [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI to manage Carvel packages in a convenient way.
* Ensure [kapp-controller](https://carvel.dev/kapp-controller) is deployed in your Kubernetes cluster. You can do that with Carvel
[`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

## Dependencies

Spring Boot Conventions requires the Cartographer package to be already installed in the cluster. You can install it from the [Kadras package repository](https://github.com/arktonix/kadras-packages).

## Installation

You can install the Spring Boot Conventions package directly or rely on the [Kadras package repository](https://github.com/arktonix/kadras-packages)
(recommended choice).

Follow the [instructions](https://github.com/arktonix/kadras-packages) to add the Kadras package repository to your Kubernetes cluster.

If you don't want to use the Kadras package repository, you can create the necessary `PackageMetadata` and
`Package` resources for the Spring Boot Conventions package directly.

```shell
kubectl create namespace carvel-packages
kapp deploy -a spring-boot-conventions-package -n carvel-packages -y \
    -f https://github.com/arktonix/spring-boot-conventions/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/spring-boot-conventions/releases/latest/download/package.yml
```

Either way, you can then install the Spring Boot Conventions package using [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl).

```shell
kctrl package install -i spring-boot-conventions \
    -p spring-boot-conventions.packages.kadras.io \
    -v 0.1.0 \
    -n carvel-packages
```

You can retrieve the list of available versions with the following command.

```shell
kctrl package available list -p spring-boot-conventions.packages.kadras.io
```

You can check the list of installed packages and their status as follows.

```shell
kctrl package installed list -n carvel-packages
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
    -v 0.1.0 \
    -n carvel-packages \
    --values-file values.yml
```

## Documentation

For documentation specific to Cartographer Conventions, check out [github.com/vmware-tanzu/cartographer-conventions](https://github.com/vmware-tanzu/cartographer-conventions).

## Supply Chain Security

This project is compliant with level 2 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level2.svg" alt="The SLSA Level 2 badge" width=200>
