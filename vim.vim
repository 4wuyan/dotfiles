" ln -s <this_file> ~/.vimrc
" or in ~/.vimrc
" source <this_file>

"----------------------------------------------------------------------
" General
"----------------------------------------------------------------------

set nocompatible " Avoid using obsolete vi commands
if has("mouse") | set mouse=a | endif
if has("mouse_sgr") | set ttymouse=sgr | endif " Mouse works beyond column 223
set backspace=indent,eol,start " Make BACKSPACE act normally as it's expected
set encoding=utf8
set ruler
autocmd BufWritePre * %s/\s\+$//e "automatically trim trailing white space on save
"Jump to the last position when reopening a file (:help last-position-jump)
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
filetype plugin indent on
set breakindent  " Keep indentation when wrapping long lines
set hlsearch


"----------------------------------------------------------------------
" Run
"----------------------------------------------------------------------

"Press F5 to run python
  autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
  autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
  autocmd FileType python vmap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>


"----------------------------------------------------------------------
" GUI Settings
"----------------------------------------------------------------------

if has('gui_running')
  colorscheme desert
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  set guifont=Consolas:h13
endif


"----------------------------------------------------------------------
" Colors
"----------------------------------------------------------------------
set background=dark
syntax on
"Less obtrusive colors
  "override other color settings above
  highlight LineNr ctermfg=Grey guifg=Grey
  highlight Comment ctermfg=Grey guifg=Grey
"Readable diff colors
  if &diff
    highlight DiffAdd    ctermbg=22
    highlight DiffDelete ctermbg=52
    highlight DiffChange ctermbg=8
    highlight DiffText   ctermbg=17
  endif
