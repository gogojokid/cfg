vim9script

# Format

filetype on
filetype plugin on
filetype indent on
set fileformat=unix
set encoding=utf-8
set textwidth=0
set nocompatible
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

# Visual {{{1

syntax on
set showcmd
set verbose=0
set fillchars+=vert:\▏
set foldmethod=marker
set ruler
set rulerformat=%55(%=%Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ 0x%B\ C:%c\ L:%l/%L\ %oB\ %p%%%)
set statusline=[%n]\ %<%F%M%r%h%w\ %#StatusLineNC#%=%##\ %Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ 0x%B\ C:%c\ L:%l/%L\ %oB\ %p%%
&t_SI = &t_SI .. "\e[5 q" #SI = INSERT mode
&t_SR = &t_SR .. "\e[3 q" #SR = REPLACE mode
&t_EI = &t_EI .. "\e[1 q" #EI = NORMAL mode (ELSE)

augroup netrw_stl
	autocmd!
	autocmd FileType netrw setlocal statusline=%n\ %<%f\ %=%L
augroup END

# Line Number {{{2

const NO_WRITE = ['netrw', 'help']

def SetLineNumber(): void
    if index(NO_WRITE, &filetype) > -1
        return
    else
        setlocal relativenumber
    endif
enddef

def SetNoLineNumber(): void
    if index(NO_WRITE, &filetype) > -1
        return
    else
        setlocal norelativenumber
    endif
enddef

var line_number_sleep = {
    replace: true,
    group: 'LineNumberSleep',
    event: 'KeyInputPre',
    pattern: '*',
    cmd: 'call EnableLineNumber()'
}

def EnableLineNumber(): void
    SetLineNumber()
    autocmd_delete([line_number_sleep])
    autocmd_add([
        {
            replace: true,
            group: 'LineNumberAwaken',
            event: 'WinEnter',
            pattern: '*',
            cmd: 'call SetLineNumber()'
        }, {
            replace: true,
            group: 'LineNumberAwaken',
            event: 'WinLeave',
            pattern: '*',
            cmd: 'call SetNoLineNumber()'
        }, {
            replace: true,
            group: 'LineNumberAwaken',
            event: 'CursorHold',
            pattern: '*',
            cmd: 'call DisableLineNumber()'
        }
    ])
enddef

def DisableLineNumber(): void
    SetNoLineNumber()
    autocmd_delete([{group: 'LineNumberAwaken'}])
    autocmd_add([line_number_sleep])
enddef

autocmd_add([line_number_sleep])
# }}}
# }}}

# Search

set ignorecase
set smartcase
set incsearch
set hlsearch

# Interacte 

set noswapfile
set ttimeout
set ttimeoutlen=5
set mouse=a
set scrolloff=40
# set virtualedit=all
set undofile
set undodir=~/.vim/undodir
set history=1000
set wildmode=list:longest,full
set wildoptions=fuzzy,tagfile
set wildignore=*.docx,*.jpg,*.png,*.exr,*.tif,*.gif,*.hrd,*.svg,*.fbx,*.gitf,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set clipboard+=unnamedplus

# Mapping {{{
         
g:mapleader = " "

nnoremap gcl <ScriptCmd>g:NcToggleRight()<CR>
nnoremap gch <ScriptCmd>g:NcToggleLeft()<CR>
xnoremap gcj :NcToggleDownV<CR>
xnoremap gck :NcToggleUpV<CR>
xnoremap gcl :NcToggleRightV<CR>
xnoremap gch :NcToggleLeftV<CR>

# support meta/alt modifier
var c: string
for i in range(97, 122)
  c = nr2char(i)
  exec "set <M-" .. c .. ">=\e" .. c
endfor
c = null_string

# support wsl copy to windos clipboard
if executable('clip.exe')
	vnoremap <silent> <C-c> :w !clip.exe<CR><CR>
endif

# fast motion
nnoremap \ :
nnoremap Y y$
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <A-j> <C-w>-
nnoremap <A-k> <C-w>+
nnoremap <A-h> <C-w><
nnoremap <A-l> <C-w>>

# common features
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
nnoremap <silent> <C-n> :set relativenumber!<CR>:set cursorline!<CR>
inoremap <silent> <C-s> <Esc>:Lexplore<CR>
nnoremap <silent> <C-s> :Lexplore<CR>
inoremap <silent> <A-s> <Esc>:Lexplore %:p:h<CR>
nnoremap <silent> <A-s> :Lexplore %:p:h<CR>

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
g:netrw_winsize = 20
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

autocmd_add([{replace: true, group: 'NetrwMap', event: 'Filetype', pattern: 'netrw', cmd: 'NetrwMapping()'}])
# }}}

# Plugin {{{

packadd! matchit
packadd! editorconfig
packadd! comment
packadd! nocomment
packadd! vim

# Editorconfig
g:EditorConfig_max_line_indicator = 'exceeding'

# Comment
autocmd_add([
    {
        replace: true,
        group: 'CommentOverwrite',
        event: 'Filetype',
        pattern: 'c',
        cmd: 'setlocal commentstring=//\ %s'
    }
])

# Nord
# let g:nord_cursor_line_number_background=1
g:nord_italic = 1
g:nord_italic_comments = 1
# }}}

# Color

set termguicolors
colorscheme nord

if !&diff
	hi Normal guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE
	hi Folded guibg=NONE ctermbg=NONE
	hi TablineSel guibg=NONE
	hi StatusLineNC guibg=NONE
endif
