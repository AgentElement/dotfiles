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
    -- PACKER
    -- 'https://github.com/wbthomason/packer.nvim',

    ---------------------------------------------------------------------------
    -- VISUALS

    -- Color scheme
    'https://github.com/navarasu/onedark.nvim',

    -- Icons
    'https://github.com/kyazdani42/nvim-web-devicons',
    'https://github.com/ryanoasis/vim-devicons',

    -- View indentation guides
    'https://github.com/lukas-reineke/indent-blankline.nvim',

    -- Status bar
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Smooth scrolling
    -- 'https://github.com/psliwka/vim-smoothie'

    -- Semantic highlighting
    'https://github.com/RRethy/vim-illuminate',

    -- Colors
    'https://github.com/brenoprata10/nvim-highlight-colors',

    ---------------------------------------------------------------------------
    -- GI

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
    'https://github.com//vim-floaterm',

    -- Better commenting
    'https://github.com/preservim/nerdcommenter',

    -- Neovim sidebar file manager
    {
        'https://github.com/kyazdani42/nvim-tree.lua',
        dependencies = { 'https://github.com/kyazdani42/nvim-web-devicons' },
    },

    -- Improved tab bar
    'https://github.com/romgrk/barbar.nvim',

    -- Autoformatting
    'https://github.com/Chiel92/vim-autoformat',

    -- Startup screen
    'https://github.com/mhinz/vim-startify',

    -- ASCII diagrams in vim
    'https://github.com/jbyuki/venn.nvim',

    -- Better / searching
    'https://github.com/junegunn/vim-slash',

    ---------------------------------------------------------------------------
    -- LANGUAGE

    -- Treesitter
    {
        'https://github.com/nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- LSP installer
    -- "https://github.com/williamboman/mason.nvim",

    -- mason/lspconfig bridge
    -- "https://github.com/williamboman/mason-lspconfig.nvim",

    -- LSP configuration
    "https://github.com/neovim/nvim-lspconfig",

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


    -- LaTeX suite
    -- 'https://github.com/lervag/vimtex'

    -- C++ clangd_extensions
    'https://github.com/p00f/clangd_extensions.nvim',

    -- Rust-tools
    'https://github.com/simrat39/rust-tools.nvim',
})
