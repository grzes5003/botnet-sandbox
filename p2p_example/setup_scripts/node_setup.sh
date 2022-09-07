#!/usr/bin/env bash

apk --update --no-cache add nodejs npm

ROOT="/home/vagrant"
cd "$ROOT/shared" || exit 5

sudo npm install

chmod a+x index.js
./index.js -n me

