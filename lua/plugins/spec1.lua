return {
  -- the colorscheme should be available when starting Neovim
  -- {
  --   "folke/tokyonight.nvim",
  --   -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   -- priority = 1000, -- make sure to load this before all the other start plugins
  --   -- config = function()
  --   --   -- load the colorscheme here
  --   --   vim.cmd([[colorscheme tokyonight]])
  --   -- end,
  -- },

  {
    "nvim-lua/plenary.nvim",
  },

  {
    "nvim-telescope/telescope.nvim",
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup {
	    icons = false,
        }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- config = function () 
    --   local configs = require("nvim-treesitter.configs")

    --   configs.setup({
    --       ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
    --       sync_install = false,
    --       highlight = { enable = true },
    --       indent = { enable = true },  
    --     })
    -- end
  },

  {
    "nvim-treesitter/playground",
  },

  {
    "theprimeagen/harpoon",
  },
  {
    "mbbill/undotree",
  },

  {
    "tpope/vim-fugitive",
  },

  --{
  --  'jose-elias-alvarez/null-ls.nvim',
  --  event = "VeryLazy",
  --  opts = function()
  --      return require "kaushtuk.null-ls"
  --  end,
  --},

  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
  {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "clangd",
            "clang-format",
        }
    }
  },
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},

   -- I have a separate config.mappings file where I require which-key.
  -- With lazy the plugin will be automatically loaded when it is required somewhere
  -- { "folke/which-key.nvim", lazy = true },

  -- {
  --   "nvim-neorg/neorg",
  --   -- lazy-load on filetype
  --   ft = "norg",
  --   -- options for neorg. This will automatically call `require("neorg").setup(opts)`
  --   opts = {
  --     load = {
  --       ["core.defaults"] = {},
  --     },
  --   },
  -- },

  -- {
  --   "dstein64/vim-startuptime",
  --   -- lazy-load on a command
  --   cmd = "StartupTime",
  --   -- init is called during startup. Configuration for vim plugins typically should be set in an init function
  --   init = function()
  --     vim.g.startuptime_tries = 10
  --   end,
  -- },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   -- load cmp on InsertEnter
  --   event = "InsertEnter",
  --   -- these dependencies will only be loaded when cmp loads
  --   -- dependencies are always lazy-loaded unless specified otherwise
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --   },
  --   config = function()
  --     -- ...
  --   end,
  -- },

  -- -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- -- So for api plugins like devicons, we can always set lazy=true
  -- { "nvim-tree/nvim-web-devicons", lazy = true },

  -- -- you can use the VeryLazy event for things that can
  -- -- load later and are not important for the initial UI
  -- { "stevearc/dressing.nvim", event = "VeryLazy" },

  -- {
  --   "Wansmer/treesj",
  --   keys = {
  --     { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
  --   },
  --   opts = { use_default_keymaps = false, max_join_length = 150 },
  -- },

  -- {
  --   "monaqa/dial.nvim",
  --   -- lazy-load on keys
  --   -- mode is `n` by default. For more advanced options, check the section on key mappings
  --   keys = { "<C-a>", { "<C-x>", mode = "n" } },
  -- },

  -- -- local plugins need to be explicitly configured with dir
  -- { dir = "~/projects/secret.nvim" },

  -- -- you can use a custom url to fetch a plugin
  -- { url = "git@github.com:folke/noice.nvim.git" },

  -- -- local plugins can also be configured with the dev option.
  -- -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from GitHub
  -- -- With the dev option, you can easily switch between the local and installed version of a plugin
  -- { "folke/noice.nvim", dev = true },
}
