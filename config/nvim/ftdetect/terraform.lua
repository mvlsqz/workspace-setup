if vim.filetype then
  vim.filetype.add({
    pattern = {
      [".*/.*%.tf"] = "terraform",
    },
  })
else
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
      "*/*.tf",
    },
    callback = function()
      vim.bo.filetype = "terraform"
    end,
  })
end
