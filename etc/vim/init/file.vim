augroup markdown_group 
  autocmd! 
augroup END 

autocmd markdown_group BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd markdown_group BufRead,BufNewFile *.md  set filetype=markdown
