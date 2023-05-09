#!/usr/bin/env bash

. ~/.bashrc

echo ">>> npm install -g bower "
npm install -g bower 

echo ">>> npm install -g grunt --force"
npm install -g grunt --force

echo ">>> npm install -g grunt-cli --force"
npm install -g grunt-cli --force

echo ">>> npm install -g grunt-compass --save-dev"
npm install -g grunt-compass --save-dev --force

echo ">>> npm install -g grunt-contrib-compass --save-dev"
npm install -g grunt-contrib-compass --save-dev --force
