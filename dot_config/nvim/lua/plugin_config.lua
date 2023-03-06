-- Colorscheme
require('onedark').setup {
    style = 'warmer'
}

require('onedark').load()

-- lualine
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
            list = {
                { key = "<C-w>", action = "close" },
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

-- nvim-cmp
local cmp = require('cmp')
if cmp == nil then
    error("nvim-cmp missing!", 1)
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },

    mapping = cmp.mapping.preset.insert({
        ['<TAB>'] = cmp.mapping.confirm({ select = true }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        --        ['<S-TAB>'] = cmp.mapping({
        --            c = cmp.mapping.confirm({ select = false }),
        --        }),

        --        ['<TAB>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    }),

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


cmp.setup.cmdline(':', {
    sources = {
        { name = 'buffer' }
    }
})

-- OpenSCAD
require('openscad')
vim.g.openscad_load_snippets = true
