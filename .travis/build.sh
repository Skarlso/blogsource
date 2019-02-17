#!/bin/sh

set -e
set -x

mkdir /opt/blog
git clone https://github.com/Skarlso/blogsource.git /opt/app
echo Build started on `date`
cd /opt/app
hugo --theme hugo-future-imperfect
cp -R public/* /opt/blog
