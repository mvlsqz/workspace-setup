return {
  "tnfru/nvim-venv-detector",
  event = "VimEnter",
  config = function()
    require("venv_detector").setup()
  end,
}
