-- NVIM SETTINGS --------------------------------------------------------------

-- Disable line wrapping
vim.opt.wrap=false

-- Enable 24-bit colors
vim.opt.termguicolors=true

-- Enable syntax highlighting
vim.opt.syntax='on'

-- Turn on line numbers
vim.opt.number=true

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

-- Highlight matching braces/parens
vim.opt.showmatch=true

-- Vertical ruler at 80 chars
vim.opt.colorcolumn="80"

-- The statusline shows the current mode, no need the redundant mode underneath
vim.opt.showmode=false

-- Allow unwritten buffers to be hidden
vim.opt.hidden=true

-- Enable mouse support
vim.opt.mouse='a'

-- Don't save blank windows on session save
vim.opt.sessionoptions:remove('blank')

-- Vertical bar seperator style
vim.opt.fillchars:append('vert:▎')

-- Ensure the cursor remains at least three lines above the lowest line while
-- scrolling
vim.opt.scrolloff=3

-- Show - for trailing spaces
vim.opt.listchars = {
    trail="~",
    tab="» ",
}
vim.opt.list=true

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

-- Make leader key , instead of \
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'


-- Set hover window background color to normal background color and hover
-- window border color to comment color
vim.opt.winhighlight="Normal:None,Pmenu:None,FloatBorder:Comment"

require('plugins')
require('plugin_config')
require('cmp_config')
require('lsp')
require('keybindings')

