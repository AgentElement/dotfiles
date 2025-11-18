local M = {}

local opts = { noremap = true, silent = true }

M.keybindings = {
    { 'n', '<leader>ll', ':TexlabBuild<CR>',                        opts },
    { 'n', '<Tab>',      'gt',                                      opts },
    { 'n', '<S-Tab>',    'gT',                                      opts },
    { 'n', '<C-t>',      ':tabnew<CR>',                             opts },

    { 'v', '<leader>vb', ':VBox<CR>',                               opts },

    -- Window navigation
    { 'n', '<C-H>',      '<C-W><C-H>',                              opts },
    { 'n', '<C-J>',      '<C-W><C-J>',                              opts },
    { 'n', '<C-K>',      '<C-W><C-K>',                              opts },
    { 'n', '<C-L>',      '<C-W><C-L>',                              opts },

    { 'n', '<F1>',       '<nop>',                                   opts },

    { 'n', '<leader>e',  ':ToggleTerm<CR>',                         opts },
    { 't', '<leader>e',  '<C-\\><C-n>:ToggleTerm<CR>',              opts },

    { 'n', '<leader>ff', '<cmd>Telescope find_files<CR>',           opts },
    { 'n', '<leader>fg', '<cmd>Telescope live_grep<CR>',            opts },
    { 'n', '<leader>fb', '<cmd>Telescope buffers<CR>',              opts },
    { 'n', '<leader>fh', '<cmd>Telescope help_tags<CR>',            opts },
    { 'n', '<leader>fc', '<cmd>Telescope git_commits<CR>',          opts },
    { 'n', '<leader>fs', '<cmd>Telescope git_status<CR>',           opts },
    { 'n', '<leader>fd', '<cmd>Telescope lsp_document_symbols<CR>', opts },
    { 'n', '<leader>fx', '<cmd>Telescope builtin<CR>',              opts },

    { 'n', '<leader>w',  ':NvimTreeToggle<CR>',                     opts },
    { 'n', '<leader>j',  ':',                                       opts },

    { 'v', '<leader>y',  '"+y',                                     opts },
    { 'n', '<leader>p',  '"+p',                                     opts },
}

M.gitsigns_keybindings = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r)
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end
    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)

    map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end)

    map('n', '<leader>hd', gitsigns.diffthis)

    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
end

M.generate_lsp_attach_keybindings = function(tbl)
    local lsp_attach_keybindings = {
        { 'n', '<leader>k', function() vim.lsp.buf.format({ async = true }) end,          opts },
        { 'n', '<leader>h', tbl.hover_fn,                                                 opts },
        { 'n', '<leader>d', vim.diagnostic.open_float,                                    opts },
        { 'n', 'gD',        function() vim.lsp.buf.declaration({ reuse_win = true }) end, opts },
        { 'n', 'gd',        function() vim.lsp.buf.definition({ reuse_win = true }) end,  opts },
        { 'n', 'gi',        vim.lsp.buf.implementation,                                   opts },
    }
    return lsp_attach_keybindings
end

local cmp = require('cmp')
if cmp == nil then
    error("nvim-cmp missing!", 1)
end

M.cmp_mapping_keybindings = {
    ['<TAB>'] = cmp.mapping.confirm({ select = true }),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Insert
    }), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Insert
    }), { 'i', 'c' }),
}

for _, binding in pairs(M.keybindings) do
    vim.keymap.set(binding[1], binding[2], binding[3], binding[4]);
end

return M
