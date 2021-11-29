-- Colorscheme
require('onedark').setup()

-- lualine
require('lualine').setup {
    options = {
        theme = 'onedark'
    }
}

-- nvim-tree
require('nvim-tree').setup()

-- indent-blankline
-- Character for indentation guides
vim.g.indent_blankline_char = '▏'
-- vim.g.indent_blankline_char = '|'
vim.g.indent_blankline_show_trailing_blankline_indent = 0
vim.g.indent_blankline_filetype_exclude = {'help', 'text'}

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
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- LANGUAGE SERVER PROTOCOL SETTINGS
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    buf_set_keymap('n', '<F3>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require('lspconfig')

nvim_lsp.clangd.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

nvim_lsp.texlab.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

nvim_lsp.pylsp.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
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
}

nvim_lsp.rls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    },
}
