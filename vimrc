syntax enable
"let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
set nocompatible		" We're in vim mode instead of vi
set rtp+=~/.vim/bundle/Vundle.vim
filetype off
call vundle#begin()

" Vundle plugins
Plugin 'gmarik/Vundle.vim'
Bundle 'derekwyatt/vim-scala'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'flazz/vim-colorschemes'
:PluginInstall

call vundle#end()
set complete=.,w,b,u,t,i
set tags=./tags,tags;$HOME
colors base     		" dark color scheme
"set nocp				" omnicppcomplete support
set exrc 				" use .vimrc file per project(directory)
set secure              " disable unsafe commands in local .vimrc
set hidden				" allows us to switch buffers without saving
set nowrap				" don't wrap lines
set t_Co=256            " 256 color vim
set number				" show line numbers
set colorcolumn=120		" Line to determine end of column limit
" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set softtabstop=2
set fillchars=stl:=,stlnc:-,vert:\|  " Set fillchars
set expandtab			" uses spaces instead of tabs
set tabstop=4			" a tab is 4 spaces
set shiftwidth=4		" number of spaces to use for autoindenting
set smarttab			" insert tabs on the start of a line according to shiftwidth, not tabstop
set tw=119
set formatoptions+=t
" set expandtab
set smartindent
set autoindent			" always set autoindenting on
set lbr					" if wrapping a line (for display only) break between words
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
set autoread			" automatically read a file again if changed outside of vim
set cindent				" use C indenting rules
set wildmode=longest	" when using <tab> autocomplete on things like edit, complete to the longest common string
"set clipboard=unnamed	" add clipboard support
syntax on				" always use syntax highlighting
" set mouse=a       " Add mouse support (useful for tabs)

" fix arrow keys
set t_ku=OA
set t_kd=OB
set t_kl=OD
set t_kr=OC


"set foldmethod=syntax	" automatically create folds based on syntax
"set foldcolumn=4		" use 4 characters for the fold margin
"set foldlevelstart=20	" automatically unfold the first 20 levels

filetype plugin indent on

"Auto-indent entire file
nmap <F11> 1G=G
imap <F11> <ESC>1G=Ga

" BufferExplorer to F12
nmap <F12> \be

" Highlight token matching the cursor
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

"Shift-J and Shift-K for paging
nmap <S-J> 20j
nmap <S-K> 20k

"Search
set incsearch			" show search matches as you type
set ignorecase			" ignore case while searching
set smartcase			" ignore case if search pattern is all lowercase, otherwise use case
set showmatch			" set show matching parenthesis
set hlsearch			" highlight search terms
nmap <silent> ,/ :nohlsearch<CR>

" radom things
set history=1000
set undolevels=1000
set wildignore=*.swp,*.class,*.o,*.a,*.so
set visualbell			" no beeping
set noerrorbells		" seriously, no beeping
set nobackup

filetype plugin indent on
" nnoremap ; :			

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Use sudo to save when you forgot
cmap w!! w !sudo tee % >/dev/null

augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
  au BufNewFile,BufRead *.py set filetype=python syntax=python
  au BufNewFile,BufRead *.g set filetype=antlr3 syntax=antlr3
  au BufNewFile,BufRead *.pde set filetype=arduino syntax=arduino
  au BufNewFile,BufRead *.ino set filetype=arduino syntax=arduino
augroup END

autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

" delete trailing whitespace in python files on save
autocmd BufWritePre *.py :%s/\s\+$//e

" svndiff for git support
hi DiffAdd ctermfg=0 ctermbg=2 guibg='green'
hi DiffDelete ctermfg=0 ctermbg=1 guibg='red'
hi DiffChange ctermfg=0 ctermbg=3 guibg='yellow'
let g:svndiff_autoupdate=1
noremap <F3> :call Svndiff("prev")<CR>
noremap <F4> :call Svndiff("next")<CR>
noremap <F5> :call Svndiff("clear")<CR>

" Run NERDtree by default
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

let NERDChristmasTree=1
let NERDTreeIgnore = ['\.pyc$']
set path+=./**

" pathogen
call pathogen#infect()

" ctrl-p
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-t>'

" set wildignore+=blackflipper/**
" noremap <C-t> :call fuf#setOneTimeVariables(['g:fuf_coveragefile_globPatterns',['**/*.py', '**/*.html', '**/*.js', '**/*.json', '**/*.css', '**/*.xml', '**/*.java', '**/*.pig', '**/*.pdsc']])\|FufCoverageFile<CR>
