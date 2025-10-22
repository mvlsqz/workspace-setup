return { -- File explorer
  {
    {
      "nvim-mini/mini.files",
      opts = {
        mappings = {
          close = "<ESC>",
          go_in = "l",
          go_in_plus = "<CR>",
          go_out = "h",
          go_out_plus = "-",
          mark_goto = "'",
          mark_set = "m",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
      },
      keys = {
        {
          "<leader>fe",
          function()
            require("mini.files").open(vim.fn.getcwd())
          end,
          desc = "Open file explorer",
        },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
    },
  },
}
