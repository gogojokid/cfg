vim9script

import autoload './.vim/pack/syntax/opt/lsp/autoload/lsp/lsp.vim'

const FILETYPE = 'FileType'
const ALL = '*'
const NO_WRITE = ['netrw']

const LINE_NUMBER_NO = {
    replace: true,
    event: 'CursorMoved',
    pattern: ALL,
    cmd: 'call OnLineNumber()'
}

const LINE_NUMBER_ON = [
    {
        replace: true,
        event: 'WinEnter',
        pattern: ALL,
        cmd: 'call EnableLineNumber()'
    }, {
        replace: true,
        event: 'WinLeave',
        pattern: ALL,
        cmd: 'call DisableLineNumber()'
    }, {
        replace: true,
        event: 'InsertEnter',
        pattern: ALL,
        cmd: 'setlocal norelativenumber'
    }, {
        replace: true,
        event: 'InsertLeave',
        pattern: ALL,
        cmd: 'setlocal relativenumber'
    }, {
        replace: true,
        event: 'CursorHold',
        pattern: ALL,
        cmd: 'call NoLineNumber()'
    }
]

# Common {{{

# format
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

# visual {{{2
def ModFoldText(): string
    var line: string
    for i in range(v:foldstart, v:foldend)
        line = getline(i)
        if line =~# '^\s*$'
            continue
        else
            line = substitute(line, '\t', repeat(' ', &tabstop), 'g')
            break
        endif
        line = getline(v:foldstart)
    endfor

    var comment_char = matchstr(&l:commentstring, '^\V\.\{-}\ze%s\m')
    line = substitute(line, '^\s*' .. comment_char .. '\s*', '', '')
    var foldmarkerchar = split(&l:foldmarker, ',')[0] .. '\s*\d*'
    line = substitute(line, foldmarkerchar, '', '')

    var w = float2nr((0.45 * winwidth(0) - &foldcolumn - (&relativenumber ? 4 : 0)))
    var foldSize = 1 + v:foldend - v:foldstart
    var foldSizeStr = ' ▤ ' .. foldSize .. ' '
    var foldLevelStr = '⊟' .. v:folddashes .. ' '
    var lineCount = line("$")
    var foldPercentage = printf("%2.f", (foldSize * 1.0) / lineCount * 100) .. "%"
    var expansionString = repeat(&fillchars[12], w - strwidth(foldSizeStr .. line .. foldLevelStr .. foldPercentage))
    return foldLevelStr .. line .. foldSizeStr .. expansionString .. foldPercentage
enddef

syntax on
set showcmd
set verbose=0
set fillchars+=vert:\▏,fold:\   # ⎹
set foldmethod=marker
set foldtext=ModFoldText()
set ruler
&t_SI = &t_SI .. "\e[5 q"  # SI = INSERT mode
&t_SR = &t_SR .. "\e[3 q"  # SR = REPLACE mode
&t_EI = &t_EI .. "\e[1 q"  # EI = NORMAL mode (ELSE)
set rulerformat=%55(%=%Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ 󱊧\ %B\ \ ▥\ %c\ ▤\ %l/%L\ \ %oB\ %p%%%)
set statusline=[%n]\ %<%F%M%r%h%w\ %=%Y\ \%{&fenc}\ %{&ff}\ %q\ %k\ 󱊧\ %B\ \ ▥\ %c\ ▤\ %l/%L\ \ %oB\ %p%%
# }}}

# search
set ignorecase
set smartcase
set incsearch
set hlsearch

# interacte 
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

# netrw
g:netrw_keepdir = 0
g:netrw_winsize = 20
g:netrw_banner = 0
g:netrw_fastbrowse = 0
g:netrw_localcopydircmd = 'cp -r'
g:netrw_localmkdir = 'mkdir -p'
g:netrw_localrmdir = 'rm -r'
# }}}

# Mapping {{{
         
g:mapleader = " "

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
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K
nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L
nnoremap <A-j> <C-w>-
nnoremap <A-k> <C-w>+
nnoremap <A-h> <C-w><
nnoremap <A-l> <C-w>>

# common features
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
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

# nocomment
def MapNocomment()
    nnoremap gcl <ScriptCmd>g:NcToggleRight()<CR>
    nnoremap gch <ScriptCmd>g:NcToggleLeft()<CR>
    xnoremap gcj :NcToggleDownV<CR>
    xnoremap gck :NcToggleUpV<CR>
    xnoremap gcl :NcToggleRightV<CR>
    xnoremap gch :NcToggleLeftV<CR>
enddef

# lsp
def MapLsp(): void
    nnoremap <buffer> <Leader>s :LspDocumentSymbol<CR>
    nnoremap <buffer> <Leader>S :LspOutline<CR><C-w>p:setlocal foldcolumn=0<CR>:setlocal statusline=[%n]\ %<%F\ %=%p%%<CR>
    nnoremap <buffer> gd <Cmd>execute v:count .. 'LspGotoDeclaration'<CR>
    nnoremap <buffer> gD <Cmd>execute v:count .. 'LspGotoDefinition'<CR>
    nnoremap <buffer> gs <Cmd>LspSymbolSearch<CR>
    nnoremap <buffer> gS <Cmd>execute 'topleft' .. 'LspSymbolSearch'<CR>
    nnoremap <buffer> <Leader>gi <Cmd>execute v:count .. 'LspGotoImpl'<CR>
    nnoremap <buffer> <Leader>gt <Cmd>execute v:count .. 'LspGotoTypeDef'<CR>
    nnoremap <buffer> <C-w>d <Cmd>execute 'topleft' .. v:count .. 'LspGotoDeclaration'<CR>
    nnoremap <buffer> <C-w>D <Cmd>execute 'topleft' .. v:count .. 'LspGotoDefinition'<CR>
    nnoremap <buffer> <C-w>i <Cmd>execute 'topleft' .. v:count .. 'LspGotoImpl'<CR>
    nnoremap <buffer> <C-w>t <Cmd>execute 'topleft' .. v:count .. 'LspGotoTypeDef'<CR>
    nnoremap <buffer> <Leader>c :LspIncomingCalls<CR>
    nnoremap <buffer> <Leader>C :LspOutgoingCalls<CR>
    nnoremap <buffer> <Leader>pd <Cmd>execute v:count .. 'LspPeekDeclaration'<CR>
    nnoremap <buffer> <Leader>pD <Cmd>execute v:count .. 'LspPeekDefinition'<CR>
    nnoremap <buffer> <Leader>pi <Cmd>execute v:count .. 'LspPeekImpl'<CR>
    nnoremap <buffer> <Leader>pt <Cmd>execute v:count .. 'LspPeekTypeDef'<CR>
    nnoremap <buffer> <Leader>pr <Cmd>LspPeekReferences<CR>
    nnoremap <buffer> <Leader>ps <Cmd>LspShowSignature<CR>
    nnoremap <buffer> <Leader>pc <Cmd>LspSubTypeHierarchy<CR>
    nnoremap <buffer> <Leader>pp <Cmd>LspSuperTypeHierarchy<CR>
    nnoremap <F2> :LspRename
    nnoremap <buffer> <F3> <Cmd>LspShowReferences<CR>
    nnoremap <buffer> <F4> <Cmd>LspDiag show<CR>
    nnoremap <buffer> <F5> <Cmd>LspSwitchSourceHeader<CR>
    xnoremap <silent> <Leader>= <Cmd>LspSelectionExpand<CR>
    xnoremap <silent> <Leader>- <Cmd>LspSelectionShrink<CR>
enddef
# }}}

# Plugin {{{

packadd! matchit
packadd! editorconfig
packadd! comment
packadd! nocomment
packadd! vim
packadd lsp

# editorconfig
g:EditorConfig_max_line_indicator = 'exceeding'

# nord
# let g:nord_cursor_line_number_background=1
g:nord_italic = 1
g:nord_italic_comments = 1

# nocomment
MapNocomment()

# lsp
g:LspAddServer([
    {
        name: 'neocmakelsp',
        filetype: 'cmake',
        path: '/usr/local/bin/neocmakelsp',
        args: ['--stdio'],
        initializationOptions: {'format': true, 'lint': true}
    }
])
g:LspOptionsSet({
    'autoHighlight': true,
    'outlineOnRight': true,
    'outlineWinSize': 30,
    'showDiagOnStatusLine': true,
    'showDiagWithVirtualText': true,
    'showInlayHints': true,
    'useBufferCompletion': true,
    'filterCompletionDuplicates': true,
})

set keywordprg=:LspHover

def g:GetDiagCount(): string
    var info = lsp.ErrorCount()
    return '⨂ ' .. info['Error'] .. ' ⚠ ' .. info['Warn']
enddef

def OnLspAttached(): void
    MapLsp()
    setlocal tagfunc=lsp.TagFunc
    setlocal formatexpr=lsp.FormatExpr()
    set rulerformat=%55(%=%Y\ \%{&fenc}\ %{&ff}\ %q\ %{g:GetDiagCount()}\ %k\ 󱊧\ %B\ \ ▥\ %c\ ▤\ %l/%L\ \ %oB\ %p%%%)
    setlocal statusline=[%n]\ %<%F%M%r%h%w\ %=%Y\ \%{&fenc}\ %{&ff}\ %q\ %{g:GetDiagCount()}\ %k\ 󱊧\ %B\ \ ▥\ %c\ ▤\ %l/%L\ \ %oB\ %p%%
enddef
# }}}

# Color {{{

set termguicolors
colorscheme nord

if !&diff
	hi Normal guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE
	hi Folded guibg=NONE ctermbg=NONE
	hi TablineSel guibg=NONE
	hi StatusLineNC guibg=NONE
    hi StatusLineTermNC guibg=NONE
    hi FoldColumn guibg=NONE
endif
# }}}

# Line Number {{{

def EnableLineNumber(): void
    if !!win_gettype() || !!&buftype || index(NO_WRITE, &filetype) > -1
        return
    else
        setlocal relativenumber
    endif
enddef

def DisableLineNumber(): void
    if !!win_gettype() || !!&buftype || index(NO_WRITE, &filetype) > -1
        return
    else
        setlocal norelativenumber
    endif
enddef

def OnLineNumber(): void
    EnableLineNumber()
    autocmd_delete([LINE_NUMBER_NO])
    autocmd_add(LINE_NUMBER_ON)
enddef

def NoLineNumber(): void
    DisableLineNumber()
    autocmd_delete(LINE_NUMBER_ON)
    autocmd_add([LINE_NUMBER_NO])
enddef
# }}}

# Save {{{

def OnSave(): void
    if g:LspServerRunning(&filetype)
        :LspFormat
    else
        return
    endif
enddef
# }}}

# Netrw {{{

def OnNetrw(): void
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

    setlocal statusline=[%n]\ %<%t\ %=%L
enddef
# }}}

# Launch {{{

autocmd_add([
    {
        replace: true,
        event: FILETYPE,
        pattern: NO_WRITE[0],
        cmd: 'OnNetrw()'
    }, {
        replace: true,
        event: FILETYPE,
        pattern: ['*.c', '*.cpp', '*.h', '*.cxx'],
        cmd: 'setlocal commentstring=//\ %s'
    }, {
        replace: true,
        event: 'User',
        pattern: 'LspAttached',
        cmd: 'call OnLspAttached()'
    }, {
        replace: true,
        event: 'BufWritePre',
        pattern: ALL,
        cmd: 'call OnSave()'
    }, {
        replace: true,
        event: 'TerminalWinOpen',
        pattern: ALL,
        cmd: 'setlocal statusline=[%n]\ %<%t\ %=%{&ff}\ \ 󱊧\ %B\ \ ▥\ %c\ ▤\ %l/%L\ \ %oB\ %p%%'
    },
    LINE_NUMBER_NO
])
# }}}
