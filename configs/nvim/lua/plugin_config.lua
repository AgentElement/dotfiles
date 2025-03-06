local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
}
require('onedark').load()

require('nvim-highlight-colors').setup {}

require('leap').create_default_mappings()

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

-- nvim-tree
require('nvim-tree').setup {
    renderer = {
        indent_markers = {
            enable = true,
        }
    },
    filters = {
        dotfiles = true,
        git_ignored = false,
    }

}

-- git
require('gitsigns').setup {
    on_attach = keybindings.gitsigns_keybindings
}


-- Theorem prover
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


-- Language Server
require('minuet').setup {
    cmp = {
        enable_auto_complete = true,
    },

    throttle = 100,

    provider = 'openai_fim_compatible',
    n_completions = 1, -- recommend for local model for resource saving
    -- I recommend beginning with a small context window size and incrementally
    -- expanding it, depending on your local computing power. A context window
    -- of 512, serves as an good starting point to estimate your computing
    -- power. Once you have a reliable estimate of your local computing power,
    -- you should adjust the context window to a larger value.
    context_window = 512,
    provider_options = {
        openai_fim_compatible = {
            api_key = 'TERM',
            name = 'Llama.cpp',
            end_point = 'http://localhost:8012/v1/completions',
            -- The model is set by the llama-cpp server and cannot be altered
            -- post-launch.
            model = 'PLACEHOLDER',
            optional = {
                max_tokens = 96,
                top_p = 0.9,
            },
            -- Llama.cpp does not support the `suffix` option in FIM completion.
            -- Therefore, we must disable it and manually populate the special
            -- tokens required for FIM completion.
            template = {
                prompt = function(context_before_cursor, context_after_cursor)
                    return '<|fim_prefix|>'
                        .. context_before_cursor
                        .. '<|fim_suffix|>'
                        .. context_after_cursor
                        .. '<|fim_middle|>'
                end,
                suffix = false,
            },
        },
    },
}
