local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
}
require('onedark').load()

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

-- Fuzzy finder over lists, files, etc
require('telescope').setup {
    defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    pickers = {
        find_files = {
            hidden = true,
        }
    }
}

-- File explorer
require('nvim-tree').setup {
    renderer = {
        indent_markers = {
            enable = true,
        }
    },
    filters = {
        dotfiles = false,
        git_ignored = true,
    }

}

-- Git
require('gitsigns').setup {
    on_attach = keybindings.gitsigns_keybindings
}


-- Theorem prover
require('lean').setup {
    mappings = true,
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

require("tree-sitter-manager").setup({
    ensure_installed = "all",
})

-- Popup terminal
require('toggleterm').setup {
    -- terminal size is 0.4 * window height
    size = vim.o.lines * 0.4,
    shade_terminals = false,
    start_in_insert = false,
}


-- OpenSCAD
require('openscad')
vim.g.openscad_load_snippets = true
