require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        "texlab",
        "rust_language_server",
        "pylsp",
        "clangd",
        "cmake",
        "sumneko_lua",
    }
})

require('lspconfig')

local keybindings = require('keybindings')

local on_attach = function(client, bufnr)
    for _, binding in pairs(keybindings) do
        vim.api.nvim_buf_set_keymap(bufnr, binding[1], binding[2], binding[3], binding[4])
    end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local server_opts = {
    ["texlab"] = function(opts)
        opts.settings = {
            texlab = {
                auxDirectory = "build",
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

