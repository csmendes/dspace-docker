#!/usr/bin/env bash
. ~/.bashrc

echo ">>> umask u=rwx,g=rwx,o=rx"
umask u=rwx,g=rwx,o=rx

echo ">>> source /usr/local/rvm/scripts/rvm"
source /usr/local/rvm/scripts/rvm
# export GEM_HOME=$GEM_HOME:~/.rvm/gems/ruby-2.7.0
# export GEM_PATH=$GEM_PATH:~/.rvm/gems/ruby-2.7.0

echo ">>> rvm get head"
rvm get head

echo ">>> rvm --default use 2.2.2"
rvm --default use 2.2.2

echo ">>> rvm info"
rvm info

echo ">>> rvm user gemsets"
rvm user gemsets

