set nocompatible

"plugin 
""プラグインをインストール :PluginInstall
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

""プラグイン管理
Plugin 'VundleVim/Vundle.vim'
""マークダウン
Plugin 'plasticboy/vim-markdown'
""マークダウンプレビュー (開くコマンド :PrevimOpen)
Plugin 'previm/previm'
Plugin 'scrooloose/nerdtree'

call vundle#end()
filetype plugin indent on

""previm settings
let g:previm_open_cmd = 'open -a Google\ Chrome'
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

""NERDTree settings
let NERDTreeShowHidden = 1
map <C-n> :NERDTreeToggle<CR>

"settings
set fileencodings=utf-8,cp932
set number
set cursorline
set hlsearch
syntax enable
set incsearch
set smartindent
set clipboard+=unnamed
set laststatus=2
set wildmenu
""swap,backup,undoファイルを作成しない
set noswapfile
set nobackup
set noundofile
"key map
nnoremap <Esc><Esc> :nohlsearch<CR>


