vim.g.no_markdown_maps = 1

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local ufp = vim.b.undo_ftplugin
    if ufp and type(ufp) == "string" then
      vim.b.undo_ftplugin = ufp:gsub("%z+", " | "):gsub("\n+", " | ")
    end
  end,
})

require("core.lazy")
