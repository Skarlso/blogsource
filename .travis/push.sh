#!/bin/sh

set -e

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  git init
  git remote add origin https://${GITHUB_TOKEN}@github.com/Skarlso/skarlso.github.io.git > /dev/null 2>&1
  git pull
}

commit_website_files() {
  git add .
  git commit -am "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git push --quiet --set-upstream origin master
}

cd /opt/blog
setup_git
commit_website_files
upload_files