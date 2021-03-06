" setting

"" 基本設定

""" ファイルのエンコードをUFT-8に設定
set fenc=utf-8
""" エンコードをUTF-8に設定（vim-deviconsを正しく動作させるためにも必要）
set encoding=UTF-8
""" バックアップファイルを作らない
set nobackup
""" スワップファイルを作らない
set noswapfile
""" 編集中のファイルが変更されたら自動で読み直す
set autoread
""" バッファが編集中でもその他のファイルを開けるように
set hidden
""" 入力中のコマンドをステータスに表示する
set showcmd
""" マウススクロールを有効にする
set mouse=a

"" 見た目系

""" 行番号を表示
set number
""" 相対行表示
set relativenumber
""" 現在の行を強調表示
set cursorline
""" 現在の行を強調表示（縦）
set cursorcolumn
""" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
""" インデントはスマートインデント
set smartindent
""" 括弧入力時の対応する括弧を表示
set showmatch
""" ステータスラインを常に表示
set laststatus=2
""" コマンドラインの補完
set wildmode=list:longest
""" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap <Down> gj
nnoremap k gk
nnoremap <Up> gk
""" カーソルが一番上や下に移動した時のビープ音を消す＆画面フラッシュも消す
set vb t_vb=
""" カラースキームをicebergにする
syntax on
colorscheme iceberg
set t_Co=256

"" Tab系

""" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
""" Tab文字を半角スペースにする
set expandtab
""" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
""" 行頭でのTab文字の表示幅
set shiftwidth=4


"" 検索系

""" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
""" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
""" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
""" 検索時に最後まで行ったら最初に戻る
set wrapscan
""" 検索語をハイライト表示
set hlsearch
""" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>


"" ウィンドウ系

" 新しいウィンドウを下に開く
set splitbelow
" 新しいウィンドウを右に開く
set splitright


"" Markdown

augroup markdown_group 
    autocmd! 
augroup END 

autocmd markdown_group BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd markdown_group BufRead,BufNewFile *.md  set filetype=markdown


"" Terminal
""" Ctrl + @ でターミナルを開く
nnoremap <silent> <C-@> :ResizeTerminalWindow<CR>
""" ウィンドウ幅変更
command! ResizeTerminalWindow call s:ResizeTerminalWindow()
function! s:ResizeTerminalWindow()
    :terminal
    :call feedkeys("\<C-w>10-")
endfunction


"" python
set pythonthreedll=$VIM/python36/python36.dll

" -------------------- dein setting --------------------
if &compatible
  set nocompatible               " Be iMproved
endif

let s:dein_path = expand('$HOME/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github からclone
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_path)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif

if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)

  let g:config_dir  = expand('~/.vim/dein/userconfig')
  let s:toml        = g:config_dir . '/plugins.toml'
  let s:lazy_toml   = g:config_dir . '/plugins_lazy.toml'

  " TOML 読み込み
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"" 外部パッケージ

""" jistr/vim-nerdtree-tabs

"""" Ctrl+\ でディレクトリツリーの表示/非表示をトグルする
nnoremap <silent><C-\> :NERDTreeTabsToggle<CR>

augroup nerdtree_group 
    autocmd! 
augroup END 

"""" vim起動時に起動する
autocmd nerdtree_group VimEnter * NERDTree
"""" vim起動時にカーソルをファイルエリアに合わせる
autocmd nerdtree_group VimEnter * wincmd p
"""" R押下で2回NERDTreeRefreshRoot()を呼ぶ 
"""" これにより，Rを1度押すだけで新規ファイルにアイコンまで反映され()を呼ぶ 
"""" これにより，Rを1度押すだけで新規ファイルにアイコンまで反映される
autocmd nerdtree_group filetype nerdtree nnoremap <buffer> R :call nerdtree#ui_glue#invokeKeyMap("R")<CR>:call nerdtree#ui_glue#invokeKeyMap("R")<CR>

""" previm/previm

"""" Ctrl + m でプレビュー
nnoremap <silent> <C-m> :PrevimOpen<CR>
"""" 自動で折りたたまないようにする
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1


""" font in NERDTree
set ambiwidth=double
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'


""" ctrlp
let g:ctrlp_working_path_mode = 0

" キャッシュディレクトリ
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
" キャッシュを終了時に削除しない
let g:ctrlp_clear_cache_on_exit = 0
" 遅延再描画
let g:ctrlp_lazy_update = 1
" CtrlPのウィンドウ最大高さ
let g:ctrlp_max_height = 20
" 無視するディレクトリ
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


""" ALE
" ファイル保存時にlinterを働かせる
let g:ale_lint_on_save = 1
" ファイルに修正が入る度にlinterを働かせる設定を無効にする
let g:ale_lint_on_text_changed = 0

" ファイルオープン時にチェックしたくない場合
let g:ale_lint_on_enter = 0

