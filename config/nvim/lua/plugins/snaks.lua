return {
  "folke/snacks.nvim",
  ---@diagnostic disable-next-line: unused-local
  opts = function(_, opts)
    local snacks = require("snacks")

    snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")

    if pcall(require, "copilot") then
      vim.g.snacks_copilot_enabled = true
      snacks
        .toggle({
          name = "Toggle (Copilot Completion)",
          color = {
            enabled = "azure",
            disabled = "orange",
          },
          get = function()
            return vim.g.snacks_copilot_enabled
          end,
          set = function(state)
            if state then
              vim.g.snacks_copilot_enabled = true
              require("copilot.command").enable()
            else
              vim.g.snacks_copilot_enabled = false
              require("copilot.command").disable()
            end
          end,
        })
        :map("<leader>at")
    end
  end,
}
