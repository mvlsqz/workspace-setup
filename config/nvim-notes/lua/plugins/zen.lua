return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)

      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*.md",
        once = true,
        callback = function()
          vim.cmd("ZenMode")
        end,
      })
    end,
    opts = {
      window = {
        width = 82,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorline = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
      },
    },
  },
}
