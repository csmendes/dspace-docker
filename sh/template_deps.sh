#!/usr/bin/env bash

echo ">>> /usr/local/rvm/scripts/rvm"
source /usr/local/rvm/scripts/rvm

echo ">>> . ~/.bashrc"
. ~/.bashrc

echo ">>> ruby dk.rb install"
ruby dk.rb install

echo ">>> ruby dk.rb init"
ruby dk.rb init

echo ">>> gem update --system"
gem update --system

echo ">>> gem install escape_utils -v 1.0.1"
gem install escape_utils -v 1.0.1 

echo ">>> gem install af --no-document"
gem install af --no-document

echo ">>> gem install sass"
gem install --no-document sass -v 3.3.14

echo ">>> gem install chunky_png"
gem install --no-document chunky_png -v 1.2

echo ">>> gem install compass-core -v 1.0.1"
gem install --no-document compass-core -v 1.0.1

echo ">>> gem install compass-import-once -v 1.0.5"
gem install --no-document compass-import-once -v 1.0.5

echo ">>> gem install rb-fsevent -v 0.9.3"
gem install --no-document rb-fsevent -v 0.9.3

echo ">>> gem install rb-inotify"
gem install --no-document rb-inotify -v 0.9

echo ">>> gem install compass"
gem install --no-document compass -v 1.0.1

echo ">>> gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)""
gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"

echo ">>> gem install nokogiri -v 1.9.1"
gem install nokogiri -v 1.9.1

echo ">>> gem install rails"
gem install rails