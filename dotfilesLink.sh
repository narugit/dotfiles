#!/bin/sh
ln -sf ~/Documents/dotfiles/.vimrc ~/.vimrc
ln -sf ~/Documents/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/Documents/dotfiles/.bashrc ~/.bashrc
ln -sf ~/Documents/dotfiles/.inputrc ~/.inputrc
rm -rf ~/.vim && ln -sfn ~/Documents/dotfiles/.vim ~/.vim
