#!/usr/bin/env bash
echo ">>> Instaling Key"
gpg --keyserver pool.sks-keyservers.net --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB 
echo ">>> Key has been instaled"

. ~/.bashrc

# echo ">>> nvm install 14.15.1"
# nvm install 14.15.1
# nvm alias default 14.15.1
# nvm use default

echo ">>> nvm install 6.5.0"
nvm install 6.5.0 
nvm alias default 6.5.0
nvm use default
