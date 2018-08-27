#!/bin/sh
echo 'start linking ...'
ln -sf ~/Documents/dotfiles/.vimrc ~/.vimrc
ln -sf ~/Documents/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/Documents/dotfiles/.bashrc ~/.bashrc
ln -sf ~/Documents/dotfiles/.inputrc ~/.inputrc
ln -sf ~/Documents/dotfiles/.gitconfig ~/.gitconfig

ln -sf ~/Documents/dotfiles/dein/userconfig/plugins.toml ~/.vim/dein/userconfig/plugins.toml
ln -sf ~/Documents/dotfiles/dein/userconfig/plugins_lazy.toml ~/.vim/dein/userconfig/plugins_lazy.toml
echo 'done!'
