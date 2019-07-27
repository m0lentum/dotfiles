" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')

" === Editing Plugins === "
" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" Easily handle surrounding brackets
Plug 'tpope/vim-surround'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Denite - Fuzzy finding, buffer management
Plug 'Shougo/denite.nvim', { 'commit': '29bfd4c53271c7a150def2388e059746ae4c1713' }

" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" === UI === "
" Fancy start screen and persistent sessions
Plug 'mhinz/vim-startify'

" File explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Colorschemes
Plug 'nightsense/strawberry'
Plug 'koirand/tokyo-metro.vim'
Plug 'sansbrina/vim-garbage-oracle', { 'branch': 'release' }

" Rainbow parentheses
Plug 'luochen1990/rainbow'

" Customized vim status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Initialize plugin system
call plug#end()
