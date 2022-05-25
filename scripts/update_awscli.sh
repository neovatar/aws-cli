#!/usr/bin/env bash
set -euxo pipefail

cd "${GITHUB_WORKSPACE:-$(pwd)}"
git config --global user.email "github-actions"
git config --global user.name "github-actions"
sudo DEBIAN_FRONTEND=noninteractive apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install libxml2-utils
curl -o .releases.xml "https://pypi.org/rss/project/awscli/releases.xml"
AWSCLI_LATEST=$(xmllint  --xpath '//channel/item[1]/title/text()' .releases.xml)
AWSCLI_CURRENT=$(grep "ARG AWSCLI_VERSION=" Dockerfile | sed -E 's/^.*=//')
if [ "${AWSCLI_CURRENT}" != "${AWSCLI_LATEST}" ]; then
  echo "update awscli from ${AWSCLI_CURRENT} to ${AWSCLI_LATEST}"
  sed -i -e "s/${AWSCLI_CURRENT}/${AWSCLI_LATEST}/" Dockerfile
  scripts/build.sh
  scripts/push.sh
  git add Dockerfile
  git commit -m"AWS CLI ${AWSCLI_LATEST}"
  git push
  # create and push the tag
  git tag --annotate "${AWSCLI_LATEST}" -m"AWS CLI ${AWSCLI_LATEST}" --force
  git push origin "${AWSCLI_LATEST}" --force
fi
