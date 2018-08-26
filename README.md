# dotfiles

This is my dotfiles' settings.

## Bash Setting

### ~/mylib/

- [tadashi-aikawa/pureline-inspired](https://github.com/tadashi-aikawa/pureline-inspired)

#### Install

   $ mkdir ~/mylib && cd ~/mylib

   $ git clone https://github.com/tadashi-aikawa/pureline-inspired  

### ~/.vim/colors/

- [tomasr/molokai](https://github.com/tomasr/molokai)

#### Install

    $ mkdir -p ~/.vim/colors && cd

    $ git clone https://github.com/tomasr/molokai

    $ mv ~/molokai/colors/molokai.vim ~/.vim/colors/

    $ rm -rf ~/molokai

## Vim Setting

### ~/.vim/pack/mypack/start/

or

### dein

1. ```$ mkdir -p ~/.cache/dein```

2. ```$ cd ~/.cache/dein```

3. ```$ curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh```

4. ```$ sh ./installer.sh ~/.cache/dein```

### nerdtree

- [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)
- [jistr/vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
- [Xuyuanp/nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)

### markdown

- [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
- [previm/previm](https://github.com/previm/previm)
- [tyru/open-browser.vim](https://github.com/tyru/open-browser.vim)

### ファイルアイコン

- [ryanoasis/vim-devicons](https://github.com/ryanoasis/vim-devicons)

#### 使用したフォント

- [Cica 2.0.0](https://github.com/miiton/Cica)

フォントをインストールしてBashのフォントに設定する
