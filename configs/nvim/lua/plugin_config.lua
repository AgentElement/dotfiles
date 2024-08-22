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

    -- Sections under an active buffer
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat' },
        lualine_y = { 'filetype' },
        lualine_z = { 'location' }
    },

    -- Sections under all other buffers
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
    renderer = {
        indent_markers = {
            enable = true,
        }
    }
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
        -- Height of the window
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

-- treesitter
require('nvim-treesitter.configs').setup {
    -- Ensure all treesitter parsers are installed
    ensure_installed = "all",

    -- Install parsers synchronously
    sync_install = false,

    -- Don't automatically install parsers
    auto_install = false,

    -- Really, don't ignore anything. I want ALL the parsers.
    ignore_install = {},

    -- I don't know what this is, but lua-ls complains if it isn't here.
    modules = {},

    -- enable highlighting and disable vim's default regex-based highlighting
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}


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
