local scheme_config = require("mvlsqz")
local daytime = scheme_config.daytime()

if daytime ~= "day" then
  vim.opt.bg = "dark"
end

return {
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
}
