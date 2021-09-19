nnoremap <silent><C-\> :NERDTreeTabsToggle<CR>

augroup nerdtree_group 
  autocmd! 
augroup END 

" Lanch nerdtree when lauching vim 
autocmd nerdtree_group VimEnter * NERDTree
" Set cursor to file area
autocmd nerdtree_group VimEnter * wincmd p
" Call twice NERDTreeRefreshRoot() when press R to applay icon in new file
autocmd nerdtree_group filetype nerdtree nnoremap <buffer> R :call nerdtree#ui_glue#invokeKeyMap("R")<CR>:call nerdtree#ui_glue#invokeKeyMap("R")<CR>

set ambiwidth=double
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
