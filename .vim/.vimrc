" Encode
set encoding=utf-8

" Format
set nocompatible
filetype on
filetype plugin on
filetype indent on
set tabstop=4
set autoindent
set smartindent
set formatoptions+=w

" Visual
syntax on
set wrap
set showcmd
set showmode
" set cursorline
set fillchars+=vert:\▏
set foldmethod=marker

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <CR> :noh<CR><CR>:<backspace>
vnoremap <C-S-C> :w !clip.exe
" Interacte
set mouse=a
set scrolloff=40
set clipboard=unnamed
set conceallevel=1
set wildmode=list:longest,full
set wildoptions=fuzzy,tagfile
set wildignore=*.docx,*.jpg,*.png,*.exr,*.tif,*.gif,*.hrd,*.svg,*.fbx,*.gitf,*.glb,*.blender,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

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
let g:netrw_winsize=27
let g:netrw_banner=0
let g:netrw_localcopydircmd='cp -r'
let g:netrw_liststyle=3
inoremap <C-b> <Esc>:Lexplore<CR>
nnoremap <C-b> :Lexplore<CR>

function! NetrwRemoveRecursive()
  if &filetype ==# 'netrw'
    cnoremap <buffer> <CR> rm -r<CR>
    normal mu
    normal mf

    try
      normal mx
    catch
      echo "Canceled"
    endtry

    cunmap <buffer> <CR>
  endif
endfunction

function! NetrwMapping()
		nmap <buffer> h -
		nmap <buffer> l <CR>
		nmap <buffer> L <CR>:Lexplore<CR>
		nmap <buffer> . gh
		nmap <buffer> P <C-w>z
		nmap <buffer> <TAB> mf
		nmap <buffer> <S-TAB> mF
		nmap <buffer> <Leader><TAB> mu
		nmap <buffer> n %:w<CR>:buffer #<CR>
		nmap <buffer> ml :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
		nmap <buffer> ft mt:echo 'Target:' . netrw#Expose("netrwmftgt")<CR>
		nmap <buffer> fr :call NetrwRemoveRecursive()<CR>
endfunction

augroup netrw
		autocmd!
		autocmd filetype netrw call NetrwMapping()
augroup END
"}}}

" Plugin
call plug#begin('~/.vim/plugged')

Plug 'nordtheme/vim'

call plug#end()

" Nord
" let g:nord_cursor_line_number_background=1
let g:nord_italic=1
let g:nord_italic_comments=1

augroup nord
	autocmd!
	autocmd ColorScheme nord highlight Folded guibg=NONE ctermbg=NONE guifg=#d8dee9
	autocmd ColorScheme nord highlight Comment guifg=#7c869a
augroup END

" Color
set termguicolors
colorscheme nord

if &diff
	
else
	hi Normal guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE
endif
