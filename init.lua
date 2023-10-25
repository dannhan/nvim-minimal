vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<C-z>", vim.cmd.redo)

vim.opt.number 		      = true
vim.opt.relativenumber 	= true
vim.opt.clipboard 	    = "unnamed,unnamedplus"
vim.opt.cursorline     	= true
vim.opt.expandtab      	= true
vim.opt.laststatus     	= 3
vim.opt.scrolloff      	= 8
vim.opt.shiftwidth     	= 2
vim.opt.swapfile       	= false
vim.opt.tabstop        	= 2
vim.opt.undofile       	= true
vim.opt.wrap           	= false
vim.opt.termguicolors   = true
vim.opt.signcolumn      = "yes:1"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "rose-pine/neovim", name = "rose-pine",
    config = function()
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require('ibl').setup {
        indent = {
          char = '┊'
        }
      }
    end,
  },
  {
    "ggandor/lightspeed.nvim",
    event = "VeryLazy",
    config = function()
      require("lightspeed").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        keymaps = {
          ["g?"]    = "actions.show_help",
          ["l"]     = "actions.select",
          ["h"]     = "actions.parent",
          ["zh"]    = "actions.toggle_hidden",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-s>"] = "",
          ["."]     = "actions.cd",
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "FileExplorer" })
    end,
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      ----- LSP
      require('mason').setup()

      local lsp = require('lsp-zero').preset("recommended")
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
      end)
      lsp.setup()

      vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = false,
      })

      ----- CMP
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "hiphish/rainbow-delimiters.nvim",
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'astro', 'c', 'css', 'glimmer', 'graphql', 'html', 'javascript',
          'lua', 'nix', 'markdown', 'php', 'python', 'scss', 'svelte', 'tsx',
          'twig', 'typescript', 'vim', 'vimdoc', 'vue', 'query',
        },
        sync_install = false,
        ignore_install = { },
        highlight = { enable = true },
        indent = { enable = true, },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        auto_install = true,

        autotag = {
          enable=true;
          enable_close_on_slash=false;
        },
        modules = {}
      }
      -- Rainbow Delimiters
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          -- [''] = rainbow_delimiters.strategy['local'],
          [''] = rainbow_delimiters.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          tsx = 'rainbow-parens',
          -- javascript = 'rainbow-parens',
        },
        highlight = {
          'RainbowDelimiterCyan',
          'RainbowDelimiterViolet',
          'RainbowDelimiterGreen',
        },
      }
    end
  }
})
