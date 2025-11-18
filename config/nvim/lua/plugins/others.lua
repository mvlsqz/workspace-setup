if true then
  return {
    {
      "folke/trouble.nvim",
      -- opts will be merged with the parent spec
      opts = { use_diagnostic_signs = true },
    },
    {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "shellcheck",
          "lua-language-server",
          "js-debug-adapter",
          "shfmt",
          "flake8",
          "gopls",
          "marksman",
          "bash-language-server",
        },
      },
    },
  }
end
return {
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "jinja",
        "jinja_inline",
        "python",
        "query",
        "regex",
        "tmux",
        "fish",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
