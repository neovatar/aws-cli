#!/bin/bash
set -euxo pipefail

function setup_git()
{
  # Allows git commit
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  git remote set-url "https://${GH_TOKEN}@github.com/neovatar/aws-cli.git"
}

function update()
{
  local AWSCLI_LATEST
  AWSCLI_LATEST=$(pip search awscli | grep -E "^awscli " | sed 's/.*(\(.*\)).*$/\1/')
  local AWSCLI_CURRENT
  AWSCLI_CURRENT=$(grep "ENV AWSCLI_VERSION" Dockerfile | awk '{print $3}' | sed -e 's/"//g')

  # Update version and push to origin, the tag it if we find a version
  # of the AWS CLI that is different than the current version at HEAD.
  if [[ "${AWSCLI_CURRENT}" != "${AWSCLI_LATEST}" ]]; then
  echo "update awscli from ${AWSCLI_CURRENT} to ${AWSCLI_LATEST}"
    git checkout -qf "${TRAVIS_BRANCH}"
    git pull origin "${TRAVIS_BRANCH}"
    sed -i -e "s/${AWSCLI_CURRENT}/${AWSCLI_LATEST}/" Dockerfile
    git commit -m"AWS CLI ${AWSCLI_LATEST}" .
    git push origin "${TRAVIS_BRANCH}"
    # create and push the tag
    git tag --annotate "${AWSCLI_LATEST}" -m"AWS CLI ${AWSCLI_LATEST}" --force
    git push origin "${AWSCLI_LATEST}" --force
  fi
}

if [[ "${TRAVIS_BRANCH}" == "master" && "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
  setup_git
  update
fi
