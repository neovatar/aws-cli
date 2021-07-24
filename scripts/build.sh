#!/usr/bin/env bash
set -euxo pipefail

cd "${GITHUB_WORKSPACE:-$(pwd)}"
docker build -t neovatar/aws-cli:latest .
