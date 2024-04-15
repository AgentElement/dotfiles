local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
    -- highlights = {
    --     CursorLine = {fmt = 'italic'}
    -- }
}

require('gen').setup({
    opts = {
        model = "mistral", -- The default model to use.
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        init = function(options) end,
        -- Function to initialize Ollama
        command = function(options)
            local body = {model = options.model, stream = true}
            return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
        end,
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        debug = false -- Prints errors and the command which is run.
    }
})

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
require('nvim-treesitter.configs').setup({
    ensure_installed = "all",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})

--
vim.g.floaterm_height = 0.3
vim.g.floaterm_width = 0.99
vim.g.floaterm_position = 'bottom'
--
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
