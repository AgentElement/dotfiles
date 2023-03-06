require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        "ltex",
        "texlab",
        "rust_analyzer",
        "pylsp",
        "clangd",
        "cmake",
        "lua_ls",
        "openscad_lsp",
        "bashls"
    }
})

require('lspconfig')

vim.diagnostic.config({
    virtual_text = false -- don't show diagnostics as inline virtual text
})

local keybindings = require('keybindings')

local on_attach = function(client, bufnr)
    -- Add keybindings that are enabled when there is a LSP active
    for _, binding in pairs(keybindings.lsp_attach_keybindings) do
        binding[4].buffer = bufnr
        vim.keymap.set(binding[1], binding[2], binding[3], binding[4])
    end


    -- Show line diagnostics automatically in hover window
    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })
end

vim.g.floaterm_width = 0.8

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Options for specific language servers
local server_opts = {
    ["texlab"] = function(opts)
        opts.settings = {
            texlab = {
                auxDirectory = "./build",
                build = {
                    args = { "-shell-escape", "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f", },
                    executable = "latexmk",
                    forwardSearchAfter = false,
                    onSave = false,
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
                },
                bibtexFormatter = 'texlab',
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

    ["lua_ls"] = function(opts)
        opts.settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    -- for nvim configs
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

-- LSP installer settings
require('mason-lspconfig').setup_handlers({
    function(server)
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            update_in_insert = true,
        }

        if server_opts[server] then
            server_opts[server](opts)
        end

        -- clangd setup is done in the clangd_extensions setup
        if server ~= 'clangd' then
            require('lspconfig')[server].setup(opts)
        end
    end
})

require("clangd_extensions").setup {
    -- pass clangd settings to lspconfig here
    server = {
        noremap = true,
        silent = true,
        on_attach = on_attach,
        capabilities = capabilities,
    }
}
