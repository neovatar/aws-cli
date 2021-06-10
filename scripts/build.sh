#!/usr/bin/env bash
set -euxo pipefail

cd ${GITHUB_WORKSPACE}
docker build -t neovatar/aws-cli:latest .
