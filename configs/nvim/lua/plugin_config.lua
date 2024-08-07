local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
}
require('onedark').load()

require('illuminate')

require('nvim-highlight-colors').setup {}

-- Status line
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'onedark'
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat' },
        lualine_y = { 'filetype' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
}

-- nvim-tree
require('nvim-tree').setup {
    view = {
        mappings = {
            list = keybindings.nvim_tree_keybindings
        }
    },
}

require('lean').setup {
    mappings = true,
    lsp = {
        init_options = {
            -- See Lean.Lsp.InitializationOptions for details and further options.

            -- Time (in milliseconds) which must pass since latest edit until elaboration begins.
            -- Lower values may make editing feel faster at the cost of higher CPU usage.
            -- Note that lean.nvim changes the Lean default for this value!
            editDelay = 0,

            -- Whether to signal that widgets are supported.
            hasWidgets = true,
        }
    },

    stderr = {
        enable = true,
        -- height of the window
        height = 5,
        -- a callback which will be called with (multi-line) stderr output
        -- e.g., use:
        --   on_lines = function(lines) vim.notify(lines) end
        -- if you want to redirect stderr to `vim.notify`.
        -- The default implementation will redirect to a dedicated stderr
        -- window.
        on_lines = nil,
    },
}

-- lsp_lines
-- require("lsp_lines").register_lsp_virtual_lines()

-- treesitter
require('nvim-treesitter.configs').setup({
    -- Ensure all treesitter parsers are installed
    ensure_installed = "all",
    
    -- enable highlighting and disable vim's default regex-based highlighting
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})


-- toggleterm
require('toggleterm').setup {
    -- terminal size is 0.4 * window height
    size = vim.o.lines * 0.4,
    shade_terminals = false,
    start_in_insert = false,
}

-- OpenSCAD
require('openscad')
vim.g.openscad_load_snippets = true
