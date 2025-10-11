return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    require("nvim-tmux-navigation").setup({
      disable_when_zoomed = true,
    })
  end,
  keys = {
    { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "Navigate to left pane" },
    { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "Navigate to down pane" },
    { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "Navigate to up pane" },
    { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "Navigate to right pane" },
    { "<C-\\>", "<cmd>TmuxNavigateLastActive<cr>", desc = "Navigate to last active pane" },
  },
}
