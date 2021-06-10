#!/usr/bin/env bash
set -euxo pipefail

cd "${GITHUB_WORKSPACE}"
docker push neovatar/aws-cli:latest

cd "${GITHUB_WORKSPACE}"
AWSCLI_VERSION=$(docker inspect neovatar/aws-cli:latest | jq -r '.[0] | .ContainerConfig.Labels.AWSCLI_VERSION')
docker tag "neovatar/aws-cli:latest" "neovatar/aws-cli:${AWSCLI_VERSION}"
docker push "neovatar/aws-cli:${AWSCLI_VERSION}"
