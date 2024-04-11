local lsp_list = {
    "texlab",
    "rust_analyzer",
    "pylsp",
    "cmake",
    "lua_ls",
    "openscad_lsp",
    "bashls",
    "clangd",
    "nixd",
}

require('lspconfig')

vim.diagnostic.config({
    virtual_text = false -- don't show diagnostics as inline virtual text
})

local keybindings = require('keybindings')

local generate_hover_function = function()
    local filetype = vim.bo.filetype;
    local hover_fn = vim.lsp.buf.hover;
    if vim.tbl_contains({ "rust" }, filetype) and packer_plugins["rust-tools.nvim"] then
        local rust_tools = require('rust-tools')
        hover_fn = rust_tools.hover_actions.hover_actions
    end
    return hover_fn
end


local on_attach = function(client, bufnr)
    -- Add keybindings that are enabled when there is a LSP active
    local lsp_attach_keybindings = keybindings.generate_lsp_attach_keybindings({
        hover_fn = generate_hover_function()
    })
    for _, binding in pairs(lsp_attach_keybindings) do
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

local capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

-- Options for specific language servers
local server_opts = {
    ["texlab"] = function(opts)
        opts.settings = {
            texlab = {
                auxDirectory = "./build",
                build = {
                    args = { "-shell-escape",
                        "-pdf",
                        "-interaction=nonstopmode",
                        "-synctex=1",
                        "%f",
                    },
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

    ["openscad_lsp"] = function(opts)
        opts.settings = {
            openscad = {
                fmt_exe = "/usr/bin/clang-format",
                fmt_style = "WebKit",
            }
        }
    end,
}

for _, server in pairs(lsp_list) do
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        update_in_insert = true,
    }

    if server_opts[server] then
        server_opts[server](opts)
    end

    require('lspconfig')[server].setup(opts)
end

require("clangd_extensions").setup {
    -- pass clangd settings to lspconfig here
    server = {
        noremap = true,
        silent = true,
        on_attach = on_attach,
        capabilities = capabilities,
    }
}
