local map = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

map('n', '<Tab>', 'gt', opts)
map('n', '<S-Tab>', 'gT', opts)
map('n', '<C-t>', ':tabnew<CR>', opts)

map('v', '<leader>vb', ':VBox<CR>', opts)

-- Window navigation
map('n', '<C-H>', '<C-W><C-H>', opts)
map('n', '<C-J>', '<C-W><C-J>', opts)
map('n', '<C-K>', '<C-W><C-K>', opts)
map('n', '<C-L>', '<C-W><C-L>', opts)

map('n', '<S-J>', '<C-E>', opts)
map('n', '<S-K>', '<C-Y>', opts)

map('n', '<F1>', '<nop>', {noremap = false})
map('n', '<F2>', ':Autoformat<CR>', opts)
map('n', '<F3>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
map('n', '<F12>', ':FloatermToggle<CR>', opts)
map('n', '<F9>', ':FloatermNew<CR>', opts)
map('n', '<F10>', ':FloatermPrev<CR>', opts)
map('n', '<F11>', ':FloatermNext<CR>', opts)
map('t', '<F9>', '<C-\\><C-n>:FloatermNew<CR>', opts)
map('t', '<F10>', '<C-\\><C-n>:FloatermPrev<CR>', opts)
map('t', '<F11>', '<C-\\><C-n>:FloatermNext<CR>', opts)
map('t', '<F12>', '<C-\\><C-n>:FloatermToggle<CR>', opts)

map('n', '<C-_>', '<plug>NERDCommenterToggle', {noremap = false})
map('v', '<C-_>', '<plug>NERDCommenterToggle<CR>gv', {noremap = false})


map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

map('n', '<C-e>', ':NvimTreeToggle<CR>', opts)

map('n', '<leader>ll', ':TexlabBuild<CR>', opts)
