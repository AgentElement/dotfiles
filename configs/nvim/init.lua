-- NVIM SETTINGS --------------------------------------------------------------

-- Disable line wrapping
vim.opt.wrap=false

-- Enable 24-bit colors
vim.opt.termguicolors=true

-- Enable filetype-specific indentation
-- filetype plugin indent on

-- Enable syntax highlighting
vim.opt.syntax='on'

-- Enable auto indentation
vim.opt.autoindent=true

-- Turn on line numbers
vim.opt.number=true

-- Make line numbers relative to cursor position
-- vim.opt.relativenumber=true

-- Number of spaces for auto indentation
vim.opt.shiftwidth=4

-- Spaces per tab to insert when tab is pressed
vim.opt.softtabstop=4

-- Tab char width
vim.opt.tabstop=4

-- Replace tabs with spaces
vim.opt.expandtab=true

-- Show line/col of cursor position
vim.opt.ruler=true

-- Case insensitive searching, except when search string contains caps
vim.opt.ignorecase=true
vim.opt.smartcase=true

-- Normal backspace behavior
vim.opt.backspace="eol,start,indent"

-- Highlight matching braces/parens
vim.opt.showmatch=true

-- Enhanced tab completion in command mode
vim.opt.wildmenu=true

-- Search for words as you type
vim.opt.incsearch=true

-- Vertical ruler at 80 chars
vim.opt.colorcolumn="80"

-- The statusline shows the current mode, no need the redundant mode underneath
vim.opt.showmode=false

-- Allow unwritten buffers to be hidden
vim.opt.hidden=true

-- Enable mouse support
vim.opt.mouse='a'

-- Enforce utf8
vim.opt.encoding='utf8'

-- Don't save blank windows on session save
vim.opt.sessionoptions:remove('blank')

-- Vertical bar seperator style
vim.opt.fillchars:append('vert:▎')

vim.opt.conceallevel=2

-- Ensure the cursor remains at least three lines above the lowest line while
-- scrolling
vim.opt.scrolloff=3

vim.opt.listchars='trail:-'

-- Virtual editing in visual block mode
vim.opt.ve='block'

-- Make new vertical splits to the right of the currently focused buffer
vim.opt.splitright=true

-- Make new horizontal splits below the currently focused buffer
vim.opt.splitbelow=true

-- nvim-tree strongly recommends eagerly disabling netrw due to race conditions 
-- at vim startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- make leader key <space> instead of \
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('plugins')
require('plugin_config')
require('cmp_config')
require('lsp')
require('keybindings')

