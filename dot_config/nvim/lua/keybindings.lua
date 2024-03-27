local M = {}

local opts = { noremap = true, silent = true }

M.keybindings = {
    { 'n', '<leader>ll', ':TexlabBuild<CR>', opts },
    { 'n', '<Tab>', 'gt', opts },
    { 'n', '<S-Tab>', 'gT', opts },
    { 'n', '<C-t>', ':tabnew<CR>', opts },

    { 'v', '<leader>vb', ':VBox<CR>', opts },

    -- Window navigation
    { 'n', '<C-H>', '<C-W><C-H>', opts },
    { 'n', '<C-J>', '<C-W><C-J>', opts },
    { 'n', '<C-K>', '<C-W><C-K>', opts },
    { 'n', '<C-L>', '<C-W><C-L>', opts },

    { 'n', '<S-J>', '<C-E>', opts },
    { 'n', '<S-K>', '<C-Y>', opts },

    { 'n', '<F1>', '<nop>', { noremap = false } },
    { 'n', '<F12>', ':FloatermToggle<CR>', opts },
    { 'n', '<F9>', ':FloatermNew<CR>', opts },
    { 'n', '<F10>', ':FloatermPrev<CR>', opts },
    { 'n', '<F11>', ':FloatermNext<CR>', opts },
    { 't', '<F9>', '<C-\\><C-n>:FloatermNew<CR>', opts },
    { 't', '<F10>', '<C-\\><C-n>:FloatermPrev<CR>', opts },
    { 't', '<F11>', '<C-\\><C-n>:FloatermNext<CR>', opts },
    { 't', '<F12>', '<C-\\><C-n>:FloatermToggle<CR>', opts },

    { 'n', '<C-/>', "<plug>NERDCommenterToggle<CR>", { noremap = true } },
    { 'v', '<C-/>', '<plug>NERDCommenterToggle<CR>gv', { noremap = true } },

    { 'n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts },
    { 'n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts },
    { 'n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts },
    { 'n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts },

    { 'n', '<C-w>', ':NvimTreeToggle<CR>', opts },

    { 'n', '<leader>ll', ':TexlabBuild<CR>', opts },
}


M.generate_lsp_attach_keybindings = function(tbl)
    local lsp_attach_keybindings = {
        { 'n', '<F2>', function() vim.lsp.buf.format({ async = true }) end, opts },
        { 'n', 'K', tbl.hover_fn, opts },
        { 'n', '<leader>]', vim.diagnostic.open_float, opts },
        { 'n', 'gD', function() vim.lsp.buf.declaration({ reuse_win = true }) end, opts },
        { 'n', 'gd', function() vim.lsp.buf.definition({ reuse_win = true }) end, opts },
        { 'n', 'gi', vim.lsp.buf.implementation, opts },
    }
    return lsp_attach_keybindings
end


M.nvim_tree_keybindings = {
    { key = "<C-w>", action = "close" },
    { key = "A", action = "edit_in_place" },
}


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
    --        ['<S-TAB>'] = cmp.mapping({
    --            c = cmp.mapping.confirm({ select = false }),
    --        }),

    --        ['<TAB>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
}

for _, binding in pairs(M.keybindings) do
    vim.keymap.set(binding[1], binding[2], binding[3], binding[4]);
end

return M
