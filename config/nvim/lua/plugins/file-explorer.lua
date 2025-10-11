return { -- File explorer
  {
    {
      "nvim-mini/mini.nvim",
      version = "*",
      config = function()
        require("mini.icons").setup()
        require("mini.files").setup({
          mappings = {
            close = "q",
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
          windows = {
            -- Maximum number of windows to show side by side
            max_number = math.huge,
            -- Whether to show preview of file/directory under cursor
            preview = false,
            -- Width of focused window
            width_focus = 50,
            -- Width of non-focused window
            width_nofocus = 15,
            -- Width of preview window
            width_preview = 25,
          },
        })
      end,
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
