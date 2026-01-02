local M = {}

M.colorscheme_flavour = function()
  local hr = tonumber(os.date("%H", os.time()))
  local flavour

  if hr >= 7 and hr < 18 then
    flavour = "latte"
  else
    flavour = "mocha"
  end

  return flavour
end

M.daytime = function()
  local hr = tonumber(os.date("%H", os.time()))
  if hr >= 7 and hr < 18 then
    return "day"
  else
    return "storm"
  end
end

M.fox_variant = function()
  local hr = tonumber(os.date("%H", os.time()))
  if hr >= 7 and hr < 18 then
    return "dawnfox"
  else
    return "tokyonight"
  end
end

M.get_active_theme = function()
  return vim.g.colors_name
end

M.get_statusline_colors = function()
  local theme = M.get_active_theme()
  if theme == "dawnfox" or theme == "duskfox" then
    local palette = require("nightfox.palette").load(M.fox_variant())
    return {
      fg = palette.fg1,
      bg = palette.bg0,
      teal = palette.cyan,
      green = palette.green,
      blue = palette.blue,
      magenta = palette.magenta,
      red = palette.red,
      orange = palette.orange,
      yellow = palette.yellow,
      violet = palette.magenta,
      cyan = palette.cyan,
      peach = palette.orange,
    }
  else -- tokyonight
    local colors, _ = require("tokyonight.colors").setup({
      style = M.daytime(),
    })
    return colors
  end
end

return M
