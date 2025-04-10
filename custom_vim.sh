" ~/.vimrc

set mouse=

" Jump to the last location in this file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
