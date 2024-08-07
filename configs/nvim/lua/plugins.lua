-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    ---------------------------------------------------------------------------
    -- VISUALS

    -- Color scheme
    'https://github.com/navarasu/onedark.nvim',

    -- Icons
    'https://github.com/kyazdani42/nvim-web-devicons',
    'https://github.com/ryanoasis/vim-devicons',

    -- Status bar
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Semantic highlighting
    'https://github.com/RRethy/vim-illuminate',

    -- Highlight color codes (eg #222222)
    'https://github.com/brenoprata10/nvim-highlight-colors',

    ---------------------------------------------------------------------------
    -- GIT

    -- Main git wrapper
    'https://github.com/tpope/vim-fugitive',

    -- Show most recent commit
    'https://github.com/rhysd/git-messenger.vim',

    -- Git diff in sign column
    'https://github.com/airblade/vim-gitgutter',


    ---------------------------------------------------------------------------
    -- UTILITIES

    -- Powerful file picker
    {
        'https://github.com/nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Floating terminal
    {'akinsho/toggleterm.nvim', version = "*", config = true},

    -- Neovim sidebar file manager
    {
        'https://github.com/kyazdani42/nvim-tree.lua',
        dependencies = { 'https://github.com/kyazdani42/nvim-web-devicons' },
    },

    -- Improved tab bar
    'https://github.com/romgrk/barbar.nvim',

    -- Autoformatting
    'https://github.com/Chiel92/vim-autoformat',

    -- ASCII diagrams in vim
    'https://github.com/jbyuki/venn.nvim',

    ---------------------------------------------------------------------------
    -- LANGUAGE

    -- Treesitter
    {
        'https://github.com/nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- LSP configuration
    'https://github.com/neovim/nvim-lspconfig',

    -- Formatter
    "https://github.com/mhartington/formatter.nvim",

    -- virtual text for warnings
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',

    -- Completion
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-cmdline',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/nvim-cmp',

    -- Luasnip completion source for cmp
    'https://github.com/saadparwaiz1/cmp_luasnip',

    -- Snippets
    'https://github.com/L3MON4D3/LuaSnip',

    -- OpenSCAD extension
    'https://github.com/salkin-mada/openscad.nvim',

    -- Rust tools
    'https://github.com/mrcjkb/rustaceanvim',

    -- C++ clangd_extensions
    'https://github.com/p00f/clangd_extensions.nvim',

    -- Lean theorem prover
    {
        'https://github.com/Julian/lean.nvim',
        event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-lua/plenary.nvim',
        },
    }
})
