return require('packer').startup(function(use)

    ---------------------------------------------------------------------------
    -- PACKER
    use 'https://github.com/wbthomason/packer.nvim'

    ---------------------------------------------------------------------------
    -- VISUALS

    -- Color scheme
    use 'https://github.com/navarasu/onedark.nvim'

    -- Icons
    use 'https://github.com/kyazdani42/nvim-web-devicons'
    use 'https://github.com/ryanoasis/vim-devicons'

    -- View indentation guides
    use 'https://github.com/lukas-reineke/indent-blankline.nvim'

    -- Status bar
    use 'https://github.com/nvim-lualine/lualine.nvim'

    -- Smooth scrolling
    use 'https://github.com/psliwka/vim-smoothie'

    -- Semantic highlighting
    use 'https://github.com/RRethy/vim-illuminate'

    ---------------------------------------------------------------------------
    -- GIT

    -- Main git wrapper
    use 'https://github.com/tpope/vim-fugitive'

    -- Show most recent commit
    use 'https://github.com/rhysd/git-messenger.vim'

    -- Git diff in sign column
    use 'https://github.com/airblade/vim-gitgutter'


    ---------------------------------------------------------------------------
    -- UTILITIES

    -- Powerful file picker
    use {
        'https://github.com/nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Floating terminal
    use 'https://github.com/voldikss/vim-floaterm'

    -- Better commenting
    use 'https://github.com/preservim/nerdcommenter'

    -- Neovim sidebar file manager
    use {
        'https://github.com/kyazdani42/nvim-tree.lua',
        requires = 'https://github.com/kyazdani42/nvim-web-devicons',
    }

    -- Improved tab bar
    use 'https://github.com/romgrk/barbar.nvim'

    -- Autoformatting
    use 'https://github.com/Chiel92/vim-autoformat'

    -- Startup screen
    use 'https://github.com/mhinz/vim-startify'

    -- ASCII diagrams in vim
    use 'https://github.com/jbyuki/venn.nvim'

    -- Better / searching
    use 'https://github.com/junegunn/vim-slash'

    ---------------------------------------------------------------------------
    -- LANGUAGE

    -- Treesitter
    use {
        'https://github.com/nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- LSP installer
    use "https://github.com/williamboman/mason.nvim"

    -- mason/lspconfig bridge
    use "https://github.com/williamboman/mason-lspconfig.nvim"

    -- LSP configuration
    use "https://github.com/neovim/nvim-lspconfig"

    -- Formatter
    use "https://github.com/mhartington/formatter.nvim"

    -- Use virtual text for warnings
    use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

    -- Completion
    use 'https://github.com/hrsh7th/cmp-nvim-lsp'
    use 'https://github.com/hrsh7th/cmp-cmdline'
    use 'https://github.com/hrsh7th/cmp-buffer'
    use 'https://github.com/hrsh7th/cmp-path'
    use 'https://github.com/hrsh7th/nvim-cmp'

    -- Luasnip completion source for cmp
    use 'https://github.com/saadparwaiz1/cmp_luasnip'

    -- Snippets
    use 'https://github.com/L3MON4D3/LuaSnip'

    -- OpenSCAD extension
    use 'https://github.com/salkin-mada/openscad.nvim'


    -- LaTeX suite
    -- use 'https://github.com/lervag/vimtex'

    -- C++ clangd_extensions
    use 'https://github.com/p00f/clangd_extensions.nvim'

    -- Rust-tools
    use 'https://github.com/simrat39/rust-tools.nvim'

    -- Automatically set up configuration after cloning packer.nvim
    -- Always to be put after plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
