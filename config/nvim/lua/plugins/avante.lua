return {
  "yetone/avante.nvim",
  opts = function(_, opts)
    -- Simply return the desired configuration table
    return {
      input = { provider = "snacks" }, -- Uses snacks.nvim for input UI
      instructions_file = "AGENTS.md", -- Avante will look for AGENTS.md in project root for instructions
      acp_providers = {
        ["opencode"] = {
          command = "opencode", -- Invokes the opencode binary
          args = { "acp" }, -- Passes "acp" argument to opencode binary
        },
      },
      provider = "opencode", -- Sets opencode as the default ACP provider
      windows = {
        width = 40, -- Sets the width of avante's windows
      },
    }
  end,
}

