#!/usr/bin/env bash
set -euxo pipefail

cd "${GITHUB_WORKSPACE}"
git config --global user.email "github-actions"
git config --global user.name "github-actions"
AWSCLI_LATEST=$(wget -q -O- "https://pypi.org/rss/project/awscli/releases.xml" | grep -m1 -E '<title>[0-9]+.[0-9]+.[0-9]+</title>' | sed -E 's/(\s*)?<(\/)?title>//g')
AWSCLI_CURRENT=$(grep "ARG AWSCLI_VERSION=" Dockerfile | sed -E 's/^.*=//')
if [[ "${AWSCLI_CURRENT}" != "${AWSCLI_LATEST}" ]]; then
  echo "update awscli from ${AWSCLI_CURRENT} to ${AWSCLI_LATEST}"
  sed -i -e "s/${AWSCLI_CURRENT}/${AWSCLI_LATEST}/" Dockerfile
  scripts/build.sh
  scripts/push.sh
  git commit -m"AWS CLI ${AWSCLI_LATEST}" .
  git push
  # create and push the tag
  git tag --annotate "${AWSCLI_LATEST}" -m"AWS CLI ${AWSCLI_LATEST}" --force
  git push origin "${AWSCLI_LATEST}" --force
fi
