call plug#begin()

" =============================================================================
" VISUALS

" Color scheme
" This color scheme does not have treesitter support
Plug 'https://github.com/joshdick/onedark.vim'
" But this one does
Plug 'https://github.com/navarasu/onedark.nvim'

" Icons
Plug 'https://github.com/kyazdani42/nvim-web-devicons'
Plug 'https://github.com/ryanoasis/vim-devicons'

" View indentation guides
Plug 'https://github.com/lukas-reineke/indent-blankline.nvim'

" Status bar
Plug 'https://github.com/itchyny/lightline.vim'

" Smooth scrolling
Plug 'https://github.com/psliwka/vim-smoothie'

" Minimap

" Plug 'https://github.com/wfxr/minimap.nvim'

" Semantic highlighting
Plug 'https://github.com/RRethy/vim-illuminate'


" =============================================================================
" Autocompletion
Plug 'https://github.com/Shougo/deoplete.nvim'

" Python autocompletion with jedi
Plug 'https://github.com/deoplete-plugins/deoplete-jedi'



" =============================================================================
" GIT
" Main git wrapper
Plug 'https://github.com/tpope/vim-fugitive'

" Show most recent commit
Plug 'https://github.com/rhysd/git-messenger.vim'

" Git diff in sign column
Plug 'https://github.com/airblade/vim-gitgutter'


" =============================================================================
" UTILITIES

"  Fuzzy finding
Plug 'https://github.com/junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'https://github.com/junegunn/fzf.vim'

" Floating terminal
Plug 'https://github.com/voldikss/vim-floaterm'

" Better commenting
Plug 'https://github.com/preservim/nerdcommenter'

" Neovim sidebar file manager
Plug 'https://github.com/kyazdani42/nvim-tree.lua'

" Improved tab bar
Plug 'https://github.com/romgrk/barbar.nvim'

" Autoformatting
Plug 'https://github.com/Chiel92/vim-autoformat'

" Startup screen
Plug 'https://github.com/mhinz/vim-startify'

" Sidebar file manager
" Plug 'https://github.com/preservim/nerdtree'

" Git for nerdtree
" Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'

" ASCII diagrams in vim
Plug 'jbyuki/venn.nvim'

" =============================================================================
" LANGUAGE

" Treesitter
" Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" GDB support for CXX and python
Plug 'https://github.com/sakhnik/nvim-gdb.git'

" OpenSCAD highlighting
Plug 'https://github.com/sirtaj/vim-openscad'

" Python
Plug 'https://github.com/python-mode/python-mode'

" Plug 'https://github.com/vim-python/python-syntax' " Better python syntax highlighting

" CXX highlighting
Plug 'https://github.com/bfrg/vim-cpp-modern'

" Latex suite
Plug 'https://github.com/lervag/vimtex'

" Linting
Plug 'https://github.com/dense-analysis/ale'

" LSP
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/williamboman/nvim-lsp-installer'
call plug#end()


" PLUGIN SETTINGS ------------------------------------------------------------

" LSP
lua << EOF
local nvim_lsp = require('lspconfig')
EOF

" Start NERDTree and put the cursor back in the other window.
" The augroup is required for lightline to behave correctly - see
" https://github.com/itchyny/lightline.vim/issues/487#issuecomment-660380223
"
" augroup NERD
" au!
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p
" autocmd VimEnter * call lightline#update()
" augroup END
"
"
" " Close NERDTree before leaving
" autocmd VimLeave * NERDTreeClose
"
" " Exit Vim if NERDTree is the only window left.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
" \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"
" " Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * silent NERDTreeMirror
"
"
" " Better NERDTreeToggle and focus
"
" function! NTToggle()
" :NERDTreeToggle
" if exists('b:NERDTree')
" wincmd p
" endif
" call lightline#update()
" endfunction
"
" let NERDTreeShowHidden=1
"
" function! NTFocus()
"     if g:NERDTree.IsOpen()
"         wincmd p
"     else
"         :NERDTreeFocus
"     endif
"     call lightline#update()
" endfunction

" ---- nvim-tree.lua
let g:nvim_tree_auto_open = 1 " Opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 " Closes the tree when it's the last window
let g:nvim_tree_auto_ignore_ft = [ 'startify' ] " Do not open with startify


" ---- onedark.vim

" Turn on colorscheme
colorscheme onedark

" ---- lightline.vim

" One Dark colorscheme
let g:lightline = {
            \ 'colorscheme': 'onedark',
            \ }

" ---- deoplete

" Enable deoplete
let g:deoplete#enable_at_startup = 1

" Close scratch window after completion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" ---- nerdtree-git-plugin

" Use Nerd fonts
" let g:NERDTreeGitStatusUseNerdFonts = 1

" ---- nerdcommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Do not create default mappings
let g:NERDCreateDefaultMappings = 0

" ---- minimap.nvim

" Autostart
" let g:minimap_auto_start = 1
" let g:minimap_auto_start_win_enter = 1
"
" let g:minimap_highlight_range = 1
"

" ---- ALE

let g:ale_c_parse_compile_commands = 1
let g:ale_lint_on_insert_leave = 1


" ---- python-mode

let g:pymode_syntax = 0 " pymode's syntaxhl sucks, use python-syntax instead

let g:pymode_lint_checkers = ['pylint', 'pep8', 'mccabe'] " pylint as linter

" I would like to murder whoever thought of setting this to 1 by default.
let g:pymode_lint_cwindow = 0 " Do not open quickfix window on lint

let g:pymode_lint_ignore = ["E501", "W", "C"] " Skip conventions

" ---- python-syntax
" let g:python_highlight_all = 1

" ---- startify
let g:startify_session_persistence = 1

" ---- indent-blankline
" Character for indentation guides
let g:indent_blankline_char = '▏'
let g:indent_blankline_show_trailing_blankline_indent = 0

let g:indent_blankline_filetype_exclude = ['help', 'text']

" ---- barbar.nvim
let bufferline = get(g:, 'bufferline', {})

" change icon seperators
let g:bufferline.icon_separator_active = '▎'
let g:bufferline.icon_separator_inactive = '▎'

" Nvim tree open/close funcitons that shift the tab bar
lua << EOF
tree = {}
tree.open = function()
require 'bufferline.state'.set_offset(30, 'FileTree')
require 'nvim-tree'.find_file(true)
end

tree.close = function()
require 'bufferline.state'.set_offset(0)
require 'nvim-tree'.close()
end

tree.toggle = function()
local view = require 'nvim-tree.view'
if view.win_open() then
    tree.close()
else
    tree.open()
end
end
EOF

" LSP
lua << EOF
require'lspconfig'.texlab.setup {
    on_attach = function(client)
    require 'illuminate'.on_attach(client)
end,
}
require'lspconfig'.cmake.setup {
    on_attach = function(client)
    require 'illuminate'.on_attach(client)
end,
}
require'lspconfig'.pylsp.setup {
    on_attach = function(client)
    require 'illuminate'.on_attach(client)
end,
}
EOF

" ---- vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'


" KEYBINDINGS ----------------------------------------------------------------

nnoremap <C-e> :lua tree.toggle()<CR>
nnoremap <leader>e :NvimTreeRefresh<CR>

nnoremap <F12> :FloatermToggle<CR>
tnoremap <F12> <C-\><C-n>:FloatermToggle<CR>

" Disable help
nmap <F1> <>

" Window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-T> :tabnew<CR>

" Open $MYVIMRC in a vsplit
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" Source $MYVIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

nnoremap <Tab> gt
nnoremap <S-Tab> gT

map <C-_> <plug>NERDCommenterToggle

" Deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

nnoremap <C-p> :Files<CR>

nnoremap <F2> :Autoformat<CR>

vnoremap <leader>vb :VBox<CR>

" Make a workspace
" nnoremap <leader>s :Obsession<CR>

" NVIM SETTINGS --------------------------------------------------------------

" Disable line wrapping
set nowrap

" Enable 24-bit colors
set termguicolors

" Enable filetype-specific indentation
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Enable auto indentation
set autoindent

" Turn on line numbers, make them relative to cursor position
set number
set relativenumber

" Number of spaces for auto indentation
set shiftwidth=4

" Spaces per tab to insert when tab is pressed
set softtabstop=4

" Tab char width
set tabstop=4

" Replace tabs with spaces
set expandtab

" Show line/col of cursor position
set ruler

" Case insensitive searching, except when search string contains caps
set ignorecase
set smartcase

" Normal backspace behavior
set backspace=eol,start,indent

" Highlight matching braces/parens
set showmatch

" Enhanced tab completion in command mode
set wildmenu

" Search for words as you type
set incsearch

" Vertical rulers
let &colorcolumn="80,120"

" Lightline shows the current mode, no need the redundant mode underneath
set noshowmode

" Allow unwritten buffers to be hidden
set hidden
"
" Enable mouse support
set mouse=a

"
set encoding=utf8

" Don't save blank windows on session save
set sessionoptions-=blank

" Vertical bar seperator style
set fillchars+=vert:\▎

set conceallevel=2

set scrolloff=3

set listchars=trail:-

" Virtual editing in visual block mode
set ve=block
