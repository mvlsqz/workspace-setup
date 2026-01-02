local scheme_config = require("mvlsqz")
local daytime = scheme_config.daytime()
local fox_variant = scheme_config.fox_variant()

if daytime ~= "day" then
  vim.opt.bg = "dark"
else
  vim.opt.bg = "light"
end

return {
  {
    "EdenEast/nightfox.nvim",
  },
  { -- colorscheme
    "folke/tokyonight.nvim",
    opts = {
      style = daytime,
      terminal_colors = true,
      transparent = true,
      styles = {
        keywords = { bold = true },
        comments = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      plugins = {
        mini_files = true,
        mini_icons = true,
        lazygit = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = fox_variant,
    },
  },
}
