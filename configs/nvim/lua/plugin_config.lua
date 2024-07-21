local keybindings = require('keybindings')

-- Colorscheme
require('onedark').setup {
    style = 'warmer',
}
require('onedark').load()

require('gen').setup({
    opts = {
        model = "llama3",    -- The default model to use.
        host = "localhost",  -- The host running the Ollama service.
        port = "11434",      -- The port on which the Ollama service is listening.
        quit_map = "q",      -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        init = function(options) end,
        -- Function to initialize Ollama
        command = function(options)
            local body = { model = options.model, stream = true }
            return "curl --silent --no-buffer -X POST http://" ..
                options.host .. ":" .. options.port .. "/api/chat -d $body"
        end,
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true,     -- Shows the prompt submitted to Ollama.
        show_model = true,      -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false,  -- Never closes the window automatically.
        debug = false           -- Prints errors and the command which is run.
    }
})


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

require('lean').setup { mappings = true }

-- lsp_lines
-- require("lsp_lines").register_lsp_virtual_lines()

-- treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = "all",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})


-- toggleterm
require('toggleterm').setup {
    size = vim.o.lines * 0.4,
    shade_terminals = false,
    start_in_insert = false,
}

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
