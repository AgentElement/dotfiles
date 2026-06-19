local lsp_list = {
    "texlab",
    "rust_analyzer",
    "ruff",
    "ty",
    "cmake",
    "lua_ls",
    "openscad_lsp",
    "bashls",
    -- "clangd", -- clangd-extensions takes care of clangd for us
    "nixd",
    "tinymist",
    "typescript-language-server",
    "superhtml"
}

vim.diagnostic.config({
    underline = true,
})

local keybindings = require('keybindings')

local on_attach = function(_client, bufnr)
    -- Add keybindings that are enabled when there is a LSP active
    local lsp_attach_keybindings = keybindings.generate_lsp_attach_keybindings({
        hover_fn = vim.lsp.buf.hover,
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
                border = 'single',
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

    ['rust_analyzer'] = function(opts)
        opts.settings = {
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                },
                check = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = {
                        "--",
                        "--no-deps",
                        "-Dclippy::correctness",
                        "-Dclippy::complexity",
                        "-Wclippy::perf",
                        "-Wclippy::pedantic",
                    },
                },
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
                    library = vim.api.nvim_get_runtime_file("lua", true),
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

    ["tinymist"] = function(opts)
        opts.settings = {
            tinymist = {
                formatterMode = "typstyle",
                formatterTabSpaces = 4,
                exportPdf = "onType",
                semanticTokens = "disable"
            }
        }
    end,

    ["leanls"] = function(opts)
        opts.init_options = {
            -- Time (in milliseconds) which must pass since latest edit until
            -- elaboration begins. Lower values may make editing feel faster at
            -- the cost of higher CPU usage. Note that lean.nvim changes the
            -- Lean default for this value!
            editDelay = 0,

            -- Whether to signal that widgets are supported.
            hasWidgets = true,
        }
    end
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

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
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
