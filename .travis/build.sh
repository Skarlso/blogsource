#!/bin/sh

set -e
set -x

mkdir /opt/blog
git clone --recurse-submodules https://github.com/Skarlso/blogsource.git /opt/app
echo Build started on `date`
cd /opt/app
hugo --theme hermit
cp -R public/* /opt/blog
