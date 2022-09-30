#!/bin/bash

set -o errexit
set -o pipefail

echo -e "\n🚢 Setting up Kubernetes cluster...\n"

kapp deploy -a test-setup -f test/test-setup -y
kubectl config set-context --current --namespace=carvel-test

# Wait for the generation of a token for the new Service Account
while [ $(kubectl get configmap kube-root-ca.crt --no-headers | wc -l) -eq 0 ] ; do
  sleep 3
done

echo -e "\n🔌 Installing test dependencies..."

kapp deploy -a kapp-controller -y \
  -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml

kapp deploy -a kadras-repo -y \
    -f https://github.com/arktonix/kadras-packages/releases/latest/download/package-repository.yml

kapp deploy -a test-dependencies -f test/test-dependencies -y

echo -e "📦 Deploying Carvel package...\n"

cd package
kctrl dev -f package-resources.yml --local -y
cd ..

echo -e "🎮 Verifying package..."

status=$(kapp inspect -a spring-boot-conventions.app --status --json | jq '.Lines[1]' -)
if [[ '"Succeeded"' == ${status} ]]; then
    echo -e "✅ The package has been installed successfully.\n"
else
    echo -e "🚫 Something wrong happened during the installation of the package.\n"
    exit 1
fi

kapp deploy -a test-data -f test/test-data -y

echo -e "\n🍃 Verifying conventions..."

kubectl wait \
  --for=condition=ConventionsApplied podintent/band-service \
  --timeout=30s

kubectl get podintent band-service -o yaml | yq '.status.template.metadata.annotations["conventions.carto.run/applied-conventions"]' > applied_conventions

cat applied_conventions
echo -e "\n"

if [[ $(cat applied_conventions | wc -l) -eq 5 ]]; then
    echo -e "✅ The Spring Boot conventions have been applied successfully.\n"
    rm applied_conventions
    exit 0
else
    echo -e "🚫 Something wrong happened while applying the conventions.\n"
    rm applied_conventions
    exit 1
fi
