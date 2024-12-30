vim9script
# Format

filetype on
filetype plugin on
filetype indent on
set fileformat=unix
set encoding=utf-8
set nocompatible
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set formatoptions+=w

# Visual {{{

syntax on
set showcmd
set fillchars+=vert:\▏
set foldmethod=marker
set ruler
set rulerformat=%55(%Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ L:%l/%L\ C:%c\ 0x%B\ %p%%\ %oB%)
augroup netrw_stl
	autocmd!
	autocmd FileType netrw setlocal statusline=%n\ %<%f\ %=%L
augroup END

set statusline=%n\ %<%F%M%r%h%w\ %#StatusLineNC#%=%##\ %Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ L:%l/%L\ C:%c\ 0x%B\ %p%%\ %oB
&t_SI = &t_SI .. "\e[5 q" #SI = INSERT mode
&t_SR = &t_SR .. "\e[3 q" #SR = REPLACE mode
&t_EI = &t_EI .. "\e[1 q" #EI = NORMAL mode (ELSE)
#Cursor settings:
#  1 -> blinking block
#  2 -> solid block 
#  3 -> blinking underscore
#  4 -> solid underscore
#  5 -> blinking vertical bar
#  6 -> solid vertical bar
# }}}

# Search

set ignorecase
set smartcase
set incsearch
set hlsearch

# Interacte {{{

set noswapfile
set ttimeout
set ttimeoutlen=5
set mouse=a
set scrolloff=40
set undofile
set undodir=~/.vim/undodir
set history=1000
set wildmode=list:longest,full
set wildoptions=fuzzy,tagfile
set wildignore=*.docx,*.jpg,*.png,*.exr,*.tif,*.gif,*.hrd,*.svg,*.fbx,*.gitf,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

# if has('unnamedplus')
# 	set clipboard+=unnamedplus
# elseif has('unnamed')
# 	set clipboard+=unnamed
# elseif executable('wl-copy') && executable('wl-paste')
# 	vnoremap <silent> z :w !wl-copy<CR><CR>
# elseif executable('clip.exe')
# 	vnoremap <silent> z :w !clip.exe<CR><CR>
# endif
# }}}
		
# Mapping
         
var c: string
for i in range(97, 122)
  c = nr2char(i)
  exec "set <M-" .. c .. ">=\e" .. c
endfor
c = null_string

nnoremap <silent> <C-l> :noh<CR><C-l>
inoremap <silent> <C-s> <Esc>:Lexplore<CR>
nnoremap <silent> <C-s> :Lexplore<CR>
inoremap <silent> <A-s> <Esc>:Lexplore %:p:h<CR>
nnoremap <silent> <A-s> :Lexplore %:p:h<CR>
nnoremap <silent> <C-n> :set relativenumber!<CR>

# Auto close {{{
# autoclose and position cursor to write text inside
inoremap <silent> ' ''<left>
inoremap <silent> ` ``<left>
inoremap <silent> " ""<left>
inoremap <silent> ( ()<left>
inoremap <silent> [ []<left>
inoremap <silent> { {}<left>
# autoclose with ; and position cursor to write text inside
inoremap <silent> '; '';<left><left>
inoremap <silent> `; ``;<left><left>
inoremap <silent> "; "";<left><left>
inoremap <silent> (; ();<left><left>
inoremap <silent> [; [];<left><left>
inoremap <silent> {; {};<left><left>
# autoclose with , and position cursor to write text inside
inoremap <silent> ', '',<left><left>
inoremap <silent> `, ``,<left><left>
inoremap <silent> ", "",<left><left>
inoremap <silent> (, (),<left><left>
inoremap <silent> [, [],<left><left>
inoremap <silent> {, {},<left><left>
# autoclose and position cursor after
inoremap <silent> '<tab> ''
inoremap <silent> `<tab> ``
inoremap <silent> "<tab> ""
inoremap <silent> (<tab> ()
inoremap <silent> [<tab> []
inoremap <silent> {<tab> {}
# autoclose 2 lines below and position cursor in the middle
inoremap <silent> '<CR> '<CR>'<ESC>O
inoremap <silent> `<CR> `<CR>`<ESC>O
inoremap <silent> "<CR> "<CR>"<ESC>O
inoremap <silent> (<CR> (<CR>)<ESC>O
inoremap <silent> [<CR> [<CR>]<ESC>O
inoremap <silent> {<CR> {<CR>}<ESC>O
# autoclose 2 lines below adding ; and position cursor in the middle
inoremap <silent> ';<CR> '<CR>';<ESC>O
inoremap <silent> `;<CR> `<CR>`;<ESC>O
inoremap <silent> ";<CR> "<CR>";<ESC>O
inoremap <silent> (;<CR> (<CR>);<ESC>O
inoremap <silent> [;<CR> [<CR>];<ESC>O
inoremap <silent> {;<CR> {<CR>};<ESC>O
# autoclose 2 lines below adding , and position cursor in the middle
inoremap <silent> ',<CR> '<CR>',<ESC>O
inoremap <silent> `,<CR> `<CR>`,<ESC>O
inoremap <silent> ",<CR> "<CR>",<ESC>O
inoremap <silent> (,<CR> (<CR>),<ESC>O
inoremap <silent> [,<CR> [<CR>],<ESC>O
inoremap <silent> {,<CR> {<CR>},<ESC>O
# }}}

# Netrw {{{
g:netrw_keepdir = 0
g:netrw_winsize = 14
g:netrw_banner = 0
g:netrw_fastbrowse = 0
g:netrw_localcopydircmd = 'cp -r'
g:netrw_localmkdir = 'mkdir -p'
g:netrw_localrmdir = 'rm -r'

def NetrwMapping(): void
		nmap <buffer> h -
		nmap <buffer> l <CR>
		nmap <buffer> L <CR>:Lexplore<CR>
		nmap <buffer> . gh
		nmap <buffer> P <C-w>z
		nmap <buffer> <TAB> mf
		nmap <buffer> <S-TAB> mF
		nmap <buffer> n Ccd%:w<CR>:buffer #<CR>
		nmap <buffer> ff :echo 'Target: ' . netrw#Expose("netrwmftgt")<CR>
		nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
		nmap <buffer> ft mt:echo 'Target: ' . netrw#Expose("netrwmftgt")<CR>
enddef

augroup netrw
		autocmd!
		autocmd filetype netrw NetrwMapping()
augroup END
#}}}

# Plugin

packadd! vim

# Nord
# let g:nord_cursor_line_number_background=1
g:nord_italic = 1
g:nord_italic_comments = 1

# Color

set termguicolors
colorscheme nord

if &diff
	
else
	hi Normal guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE
	hi Folded guibg=NONE ctermbg=NONE
	hi TablineSel guibg=NONE
	hi StatusLineNC guibg=NONE
endif
