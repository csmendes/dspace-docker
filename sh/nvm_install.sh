#!/usr/bin/env bash

echo "REMOVING $HOME/.nvm"
rm -rf $HOME/.nvm

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash  
echo "source ~/.bashrc" > ~/.bash_profile

echo "SUCCESS"
