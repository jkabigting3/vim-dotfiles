execute pathogen#infect()
syntax on
syntax enable

" Color scheme
let g:solarized_termcolors=16
set background=dark
" let g:solarized_termtrans = 1
let &t_Co=256
colorscheme solarized

" Enable features that may not be on by default
set number
set nocompatible
set ruler
set autoindent
set smartindent
set hlsearch
set mouse=a
set wildmenu
set hidden
set history=200
set updatetime=200
set cursorline
set colorcolumn=80
set listchars=tab:>-,trail:␠,nbsp:⎵,space:·
set list
set splitbelow
set splitright

" Remove trailing whitespace on save
fun! <SID>StripTrailingWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l,c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

" Remapping save and save/exit commands that I always typo
cnoremap <expr> X (getcmdtype() is# ':' && empty(getcmdline())) ? 'x' : 'X'
cnoremap <expr> W (getcmdtype() is# ':' && empty(getcmdline())) ? 'w' : 'W'
cnoremap <expr> Q (getcmdtype() is# ':' && empty(getcmdline())) ? 'q' : 'Q'

" Mapping <Ctrl+e> to toggle NERDTree
map <silent> <C-t> :NERDTreeToggle<CR>

" Enter makes search result highlighting go away
nnoremap <silent> <CR> :noh<CR><CR>

" Tabbing preferences
set tabstop=4 " How many spaces to render tabs as
set softtabstop=4 " How many spaces to insert/delete when pressing tab/backspc
set shiftwidth=4 " Automatic indentation width
set expandtab " Always write tabs as spaces
set cinoptions=(0 " Indent to last unclosed parenthesis in previous line
au FileType make setl noexpandtab " Use real tab characters in Makefile
au FileType typescript setl sw=2 ts=2 sts=2
au BufRead,BufNewFile *.md setlocal textwidth=80

" The Silver Searcher
if executable('ag')
   " Use ag over grep
   set grepprg=ag\ --nogroup\ --nocolor
   " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
   " ag is fast enough that CtrlP doesn't need to cache
   let g:ctrlp_use_caching = 0
endif

" Enable filetype plugins
syntax on
au BufNewFile,BufRead * syn sync fromstart
filetype plugin on
filetype indent on

" vim-syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers=['tsuquyomi']

" POSIX shell scripts
aug sh
    let g:is_posix = 1
aug END

" Always show GitGutter lane
if exists('&signcolumn')
    set signcolumn=yes
else
    let g:gitgutter_sign_column_always=1
endif

" Run csscomb to prettify .css files
" Uses csscomb (https://www.npmjs.com/package/csscomb)
fun! <SID>CSScomb(count, line1, line2)
    let content = getline(a:line1, a:line2)

    let tempFile = tempname() . '.' . &filetype
    call writefile(content, tempFile)
    exec "silent !csscomb " . shellescape(tempFile)

    let lines = readfile(tempFile)

    if len(lines) < a:line2
        let dline = len(lines) + 1
        exec dline . ',' . a:line2 . 'd_'
    endif
    call setline(a:line1, lines)

    redraw!
endfun

" Enables command :CSScomb to run csscomb on current file
command! -nargs=? -range=% CSScomb :call <SID>CSScomb(<count>, <line1>, <line2>, <f-args>)
