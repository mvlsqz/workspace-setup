local M = {}

M.colorscheme_flavour = function()
  local hr = tonumber(os.date("%H", os.time()))
  local flavour

  if hr > 7 and hr < 18 then
    flavour = "latte"
  else
    flavour = "mocha"
  end

  return flavour
end

M.daytime = function()
  local hr = tonumber(os.date("%H", os.time()))
  if hr > 7 and hr < 18 then
    return "day"
  else
    return "storm"
  end
end
return M
