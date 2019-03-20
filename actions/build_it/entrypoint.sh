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

root_path="$GITHUB_WORKSPACE"
blog_path="$GITHUB_WORKSPACE/.blog"
mkdir -p $blog_path
mkdir -p $root_path
cd $root_path
hugo --theme hermit
cp -R public/* $blog_path/
