" Encode

set encoding=utf-8

" Format

set nocompatible
filetype on
filetype plugin on
filetype indent on
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set formatoptions+=w

" Visual {{{

syntax on
set showcmd
set fillchars+=vert:\▏
set foldmethod=marker
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[3 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
"}}}

" Search

set ignorecase
set smartcase
set incsearch
set hlsearch

" Interacte {{{

set noswapfile
set ttimeout
set ttimeoutlen=5
set mouse=a
set scrolloff=40
set wildmode=list:longest,full
set wildoptions=fuzzy,tagfile
set wildignore=*.docx,*.jpg,*.png,*.exr,*.tif,*.gif,*.hrd,*.svg,*.fbx,*.gitf,*.glb,*.blender,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

if executable('wl-copy') && executable('wl-paste')
	set clipboard+=unnamedplus
endif
"}}}
		
" Mapping

for i in range(97,122)
  let c = nr2char(i)
  exec "set <M-".c.">=\e".c
endfor

nnoremap <C-l> :noh<CR><C-l>
inoremap <C-s> <Esc>:Lexplore<CR>
nnoremap <C-s> :Lexplore<CR>
inoremap <A-s> <Esc>:Lexplore %:p:h<CR>
nnoremap <A-s> :Lexplore %:p:h<CR>
nnoremap <C-n> :set number!<CR>:set relativenumber!<CR>
vnoremap <C-S-c> :w !clip.exe

" Auto close {{{
" autoclose and position cursor to write text inside
inoremap ' ''<left>
inoremap ` ``<left>
inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
" autoclose with ; and position cursor to write text inside
inoremap '; '';<left><left>
inoremap `; ``;<left><left>
inoremap "; "";<left><left>
inoremap (; ();<left><left>
inoremap [; [];<left><left>
inoremap {; {};<left><left>
" autoclose with , and position cursor to write text inside
inoremap ', '',<left><left>
inoremap `, ``,<left><left>
inoremap ", "",<left><left>
inoremap (, (),<left><left>
inoremap [, [],<left><left>
inoremap {, {},<left><left>
" autoclose and position cursor after
inoremap '<tab> ''
inoremap `<tab> ``
inoremap "<tab> ""
inoremap (<tab> ()
inoremap [<tab> []
inoremap {<tab> {}
" autoclose 2 lines below and position cursor in the middle
inoremap '<CR> '<CR>'<ESC>O
inoremap `<CR> `<CR>`<ESC>O
inoremap "<CR> "<CR>"<ESC>O
inoremap (<CR> (<CR>)<ESC>O
inoremap [<CR> [<CR>]<ESC>O
inoremap {<CR> {<CR>}<ESC>O
" autoclose 2 lines below adding ; and position cursor in the middle
inoremap ';<CR> '<CR>';<ESC>O
inoremap `;<CR> `<CR>`;<ESC>O
inoremap ";<CR> "<CR>";<ESC>O
inoremap (;<CR> (<CR>);<ESC>O
inoremap [;<CR> [<CR>];<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
" autoclose 2 lines below adding , and position cursor in the middle
inoremap ',<CR> '<CR>',<ESC>O
inoremap `,<CR> `<CR>`,<ESC>O
inoremap ",<CR> "<CR>",<ESC>O
inoremap (,<CR> (<CR>),<ESC>O
inoremap [,<CR> [<CR>],<ESC>O
inoremap {,<CR> {<CR>},<ESC>O
" }}}

" Netrw {{{
let g:netrw_keepdir=0
let g:netrw_winsize=14
let g:netrw_banner=0
let g:netrw_fastbrowse=0
let g:netrw_localcopydircmd='cp -r'
let g:netrw_localmkdir='mkdir -p'
let g:netrw_localrmdir='rm -r'

function! NetrwMapping()
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
endfunction

augroup netrw
		autocmd!
		autocmd filetype netrw call NetrwMapping()
augroup END
"}}}

" Plugin

packadd! vim

" Nord
" let g:nord_cursor_line_number_background=1
let g:nord_italic=1
let g:nord_italic_comments=1

" Color

set termguicolors
colorscheme nord

if &diff
	
else
	hi Normal guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE
	hi Folded guibg=NONE ctermbg=NONE
	hi TablineSel guibg=NONE
endif
