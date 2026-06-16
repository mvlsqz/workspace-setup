return {
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local smart_splits = require("smart-splits")
      vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to lower split" })
      vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to upper split" })
      vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right split" })
    end,
  },

  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen,
        default_mappings = true,
        mappings = {
          i = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
            J = {
              J = "<Esc>",
            },
          },
          t = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },

  { "hrsh7th/nvim-cmp", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },
  { "folke/todo-comments.nvim", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "echasnovski/mini.ai", enabled = false },
  { "echasnovski/mini.surround", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "echasnovski/mini.diff", enabled = false },
  { "Bilal2453/luvit-meta", enabled = false },
  { "folke/lazydev.nvim", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
}
