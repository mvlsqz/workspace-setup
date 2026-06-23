return {
  {
    "kepano/flexoki-neovim",
    lazy = false,
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "soft"
      vim.g.everforest_better_performance = 1
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { bold = true },
    },
  },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {
      styles = {
        comments = { "italic" },
        keywords = { "bold" },
      },
      integrations = {
        markview = true,
      },
    },
  },
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    opts = {
      styles = {
        italic = true,
        bold = true,
      },
    },
  },
  {
    "zenbones-theme/zenbones.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true,
      transparent = true,
      styles = {
        keywords = { bold = true },
        comments = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("mvlsqz").init()
      end,
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>t", group = "Theme" },
      },
    },
  },
}
