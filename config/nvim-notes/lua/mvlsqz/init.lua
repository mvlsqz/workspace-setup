local M = {}

M.themes = {
  { name = "Flexoki",    light = "flexoki",          dark = "flexoki",          bg_switch = true },
  { name = "Everforest", light = "everforest",       dark = "everforest",       bg_switch = true },
  { name = "Kanagawa",   light = "kanagawa-lotus",   dark = "kanagawa-wave" },
  { name = "Catppuccin", light = "catppuccin-latte",  dark = "catppuccin-mocha" },
  { name = "Rosé Pine",  light = "rose-pine-dawn",   dark = "rose-pine" },
  { name = "Zenbones",   light = "zenbones",         dark = "neobones",         bg_switch = true },
  { name = "TokyoNight", light = "tokyonight-day",   dark = "tokyonight-storm" },
  { name = "Nightfox",   light = "dawnfox",          dark = "nightfox" },
}

M.state = {
  index = 1,
  is_dark = true,
}

local state_file = vim.fn.stdpath("data") .. "/mvlsqz-theme.lua"

local function save()
  local f = io.open(state_file, "w")
  if not f then return end
  f:write(string.format("return { index = %d, is_dark = %s }\n", M.state.index, tostring(M.state.is_dark)))
  f:close()
end

local function load_state()
  local ok, data = pcall(dofile, state_file)
  if ok and type(data) == "table" and data.index and data.index >= 1 and data.index <= #M.themes then
    M.state.index = data.index
    M.state.is_dark = data.is_dark
    return true
  end
  return false
end

local function apply()
  local theme = M.themes[M.state.index]
  local mode = M.state.is_dark and "dark" or "light"
  local scheme = theme[mode]

  if theme.bg_switch then
    vim.o.background = mode
  end

  vim.cmd("colorscheme " .. scheme)
end

M.init = function()
  if not load_state() then
    local hr = tonumber(os.date("%H"))
    M.state.is_dark = not (hr >= 7 and hr < 19)
  end
  apply()
end

M.next = function()
  M.state.index = (M.state.index % #M.themes) + 1
  apply()
  save()
  vim.notify(M.themes[M.state.index].name .. (M.state.is_dark and " (dark)" or " (light)"), vim.log.levels.INFO, { title = "Theme" })
end

M.prev = function()
  M.state.index = ((M.state.index - 2 + #M.themes) % #M.themes) + 1
  apply()
  save()
  vim.notify(M.themes[M.state.index].name .. (M.state.is_dark and " (dark)" or " (light)"), vim.log.levels.INFO, { title = "Theme" })
end

M.toggle = function()
  M.state.is_dark = not M.state.is_dark
  apply()
  save()
  vim.notify(M.themes[M.state.index].name .. (M.state.is_dark and " (dark)" or " (light)"), vim.log.levels.INFO, { title = "Theme" })
end

M.select = function()
  local items = {}
  for i, t in ipairs(M.themes) do
    local marker = (i == M.state.index) and " ● " or "   "
    table.insert(items, marker .. t.name)
  end

  vim.ui.select(items, { prompt = "Colorscheme" }, function(_, idx)
    if idx then
      M.state.index = idx
      apply()
      save()
      vim.notify(M.themes[idx].name .. (M.state.is_dark and " (dark)" or " (light)"), vim.log.levels.INFO, { title = "Theme" })
    end
  end)
end

return M
