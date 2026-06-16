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

return M
