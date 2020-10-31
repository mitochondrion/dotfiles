execute pathogen#infect()

filetype plugin on

set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set ruler
set et
set ignorecase
set ch=2  "vim command line height
syntax on
set hlsearch
highlight Normal guibg=grey80
highlight Cursor guibg=Green
set bs=2
set autoindent
set number
set laststatus=2
set ruler
set ignorecase
set smartcase
set history=1000
set mouse=a

filetype plugin on

" Search for ctags file recursing up directory structure stopping at $HOME
set tags+=tags;$HOME

colors Tomorrow-Night-Bright

nmap \| :NERDTreeFind<CR>
nmap <Bslash> :NERDTreeToggle<CR>
nmap ,/ <plug>NERDCommenterToggle
vmap ,/ <plug>NERDCommenterToggle

nnoremap Y y$

"""""""""""""""""""""""""""""
" Configure line numbers (https://jeffkreeftmeijer.com/vim-number/)
"   Absolute: cursor/insert mode/unfocused buffer
"   Relative: everywhere else
"""""""""""""""""""""""""""""
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"""""""""""""""""""""""""""""
" Check .git/tags for ctags file
"""""""""""""""""""""""""""""
fun! FindTagsFileInGitDir(file)
  let path = fnamemodify(a:file, ':p:h')
  while path != '/'
    let fname = path . '/.git/tags'
    if filereadable(fname)
      silent! exec 'set tags+=' . fname
    endif
    let path = fnamemodify(path, ':h')
  endwhile
endfun

augroup CtagsGroup
  autocmd!
  autocmd BufRead * call FindTagsFileInGitDir(expand("<afile>"))
augroup END

"""""""""""""""""""""
" Use AG with ctrl+p
"""""""""""""""""""""
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

"""""""""""""""""""""""
" Use AG for searching
"""""""""""""""""""""""
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

"""""""""""""""""""""""""""""""""""
" bind K to grep word under cursor
"""""""""""""""""""""""""""""""""""
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"""""""""""""""""""""""""""""""""""""""""
" bind // to search for visual selection
"""""""""""""""""""""""""""""""""""""""""
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
