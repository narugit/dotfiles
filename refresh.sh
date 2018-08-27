#!/bin/sh
echo 'start removing ...'
rm -rf ~/.vim/dein/
echo 'done.'
echo 'making directories...'
mkdir -p ~/.vim/dein/userconfig
echo 'done.'
./dotfilesLink.sh
echo 'please open vim and wait for a while. You will asked two times to press some keys.'
