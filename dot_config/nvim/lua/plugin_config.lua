-- Colorscheme
require('onedark').setup()

-- lualine
require('lualine').setup {
    options = {
        theme = 'onedark'
    }
}

-- nvim-tree
require('nvim-tree').setup {
    view = {
        mappings = {
            list = {
                { key = "<C-e>", action = "close" },
                { key = "A", action = "edit_in_place" },
            }
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
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        custom_captures = {
            additional_vim_regex_highlighting = false,
        }
    }
}

-- vimtex
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
vim.g.vimtex_view_general_options_latexmk = '--unique'

-- startify
vim.g.startify_session_persustence = true

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

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },

    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<TAB>'] = cmp.mapping({
            c = cmp.mapping.confirm({ select = false }),
        }),

        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    }),

    experimental = {
        ghost_text = true
    },

    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})


-- clangd_extensions config
require("clangd_extensions").setup()

-- LANGUAGE SERVER PROTOCOL SETTINGS

-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({
-- virtual_text = false,
-- virtual_lines = true,
-- })

local nvim_lsp = require('lspconfig')
local lsp_installer = require "nvim-lsp-installer"

local servers = {
    "texlab",
    "rust_language_server",
    "pylsp",
    "clangd",
    "cmake",
    "sumneko_lua",
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end
-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
    -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    -- buf_set_keymap('n', '<F3>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end


local server_opts = {
    ["texlab"] = function(opts)
        opts.settings = {
            texlab = {
                auxDirectory = ".",
                bibtexFormatter = "texlab",
                build = {
                    args = { "-shell-escape", "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f", },
                    executable = "latexmk",
                    forwardSearchAfter = false,
                    onSave = true
                },
                chktex = {
                    onEdit = false,
                    onOpenAndSave = false
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                forwardSearch = {
                    args = {}
                },
                latexFormatter = "latexindent",
                latexindent = {
                    modifyLineBreaks = false
                }
            }
        }
    end,

    ["rust_analyzer"] = function(opts)
        opts.settings = {
            rust = {
                unstable_features = true,
                build_on_save = false,
                all_features = true,
            },
        }
    end,

    ["sumneko_lua"] = function(opts)
        opts.settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            }
        }
    end,

}


lsp_installer.on_server_ready(
function(server)
    local opts = {
            noremap = true,
            silent = true,
            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
              -- This will be the default in neovim 0.7+
              debounce_text_changes = 150,
            },
    }
    if server_opts[server.name] then
        -- Enhance the default opts with the server-specific ones
        server_opts[server.name](opts)
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end
)
