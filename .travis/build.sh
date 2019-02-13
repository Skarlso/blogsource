#!/bin/sh

set -e

mkdir /opt/blog
git clone https://github.com/Skarlso/blogsource.git /opt/app
echo Build started on `date`
cd /opt/app
hugo --theme terminal
cp -R public/* /opt/blog
