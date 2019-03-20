#!/bin/bash

set -e
set -x

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

setup_git() {
  git config --global user.email "bot@github.com"
  git config --global user.name "Github Actions"
  git init
  git remote add origin https://${GITHUB_TOKEN}@github.com/Skarlso/skarlso.github.io.git > /dev/null 2>&1
  git pull origin master
}

commit_website_files() {
  git add .
  git commit -am "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git push --quiet --set-upstream origin master
}

mkdir /opt/publish && cd /opt/publish
blog_path="$GITHUB_WORKSPACE/.blog"
setup_git
cp -R $blog_path/* .
commit_website_files
upload_files
