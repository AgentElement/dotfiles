local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
    -- highlights = {
    --     CursorLine = {fmt = 'italic'}
    -- }
}

require('onedark').load()

require('illuminate')

require('nvim-highlight-colors').setup {}

-- Status line
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'onedark'
    }
}

-- nvim-tree
require('nvim-tree').setup {
    view = {
        mappings = {
            list =  keybindings.nvim_tree_keybindings
        }
    },
}

-- lsp_lines
-- require("lsp_lines").register_lsp_virtual_lines()

-- indent-blankline
-- Character for indentation guides
vim.g.indent_blankline_char = '▏'
-- vim.g.indent_blankline_char = '|'
vim.g.indent_blankline_show_trailing_blankline_indent = 0
vim.g.indent_blankline_filetype_exclude = { 'help', 'text' }

-- treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

-- vimtex
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_general_viewer = 'okular'
-- vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
-- vim.g.vimtex_view_general_options_latexmk = '--unique'

-- startify
vim.g.startify_session_persistence = true

-- NERDCommenter
-- Add spaces after comment delimiters by default
vim.g.NERDSpaceDelims = true
vim.g.NERDDefaultAlign = 'left'

-- Allow commenting and inverting empty lines (useful when commenting a region)
vim.g.NERDCommentEmptyLines = true

-- Enable trimming of trailing whitespace when uncommenting
vim.g.NERDTrimTrailingWhitespace = true

-- Do not create default mappings
vim.g.NERDCreateDefaultMappings = false

-- OpenSCAD
require('openscad')
vim.g.openscad_load_snippets = true
