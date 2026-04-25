# Design Document: Integrating OpenCode Agent with avante.nvim as ACP

## 1. Introduction

This document outlines the design for configuring `avante.nvim` to use the `opencode` agent as its AI Code Partner (ACP). The `opencode` agent will serve as the AI backend for `avante.nvim`, handling code generation, suggestions, and other AI-driven functionalities.

## 2. Goals

*   Configure `avante.nvim` to use the `opencode` binary as an external ACP provider.
*   Ensure the `avante.nvim` setup properly invokes the `opencode` binary with the necessary arguments.
*   Provide a clear and functional `avante.lua` configuration file.

## 3. Assumptions

*   The `opencode` binary is installed and accessible in the system's PATH.
*   The `opencode` binary itself is configured to use Google Gemini as its AI provider (as per user's earlier input).
*   `snacks.nvim` is installed and available for use as an input provider for `avante.nvim`.
*   The `lazy.nvim` plugin manager is being used to manage Neovim plugins, and it imports configurations from the `lua/plugins` directory.

## 4. Design

### 4.1. `avante.lua` Configuration File

A new Lua configuration file, `avante.lua`, will be created in the `config/nvim/lua/plugins/` directory. This file will define the `avante.nvim` plugin and its options.

**File Path:** `/Users/io/Documents/Forks/workspace-setup/config/nvim/lua/plugins/avante.lua`

**Content:**

```lua
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
          args = { "acp" },     -- Passes "acp" argument to opencode binary
        },
      },
      provider = "opencode", -- Sets opencode as the default ACP provider
      windows = {
        width = 40, -- Sets the width of avante's windows
      },
    }
  end,
}
```

### 4.2. Explanation of Configuration Options

*   **`"yetone/avante.nvim"`**: Specifies the GitHub repository for the `avante.nvim` plugin, indicating to `lazy.nvim` that this plugin should be loaded.
*   **`opts = function(_, opts)`**: This function is called by `lazy.nvim` to retrieve the plugin's configuration options. The `opts` parameter (here `_` as we are not merging with existing `avante.nvim` internal defaults, but providing a full configuration) would normally contain default options, but in this simplified approach, we return a complete configuration table.
*   **`input = { provider = "snacks" }`**: Configures `avante.nvim` to use `snacks.nvim` for its input UI. This provides a modern and feature-rich input experience.
*   **`instructions_file = "AGENTS.md"`**: Directs `avante.nvim` to look for a file named `AGENTS.md` in the current project's root directory. This file can contain project-specific context and instructions for the AI agent, allowing for customized behavior.
*   **`acp_providers = { ["opencode"] = { command = "opencode", args = { "acp" } } }`**: This crucial section defines "opencode" as a custom ACP provider.
    *   **`command = "opencode"`**: Specifies that the `opencode` binary should be executed when this provider is used. It assumes `opencode` is available in the system's PATH.
    *   **`args = { "acp" }`**: Passes the argument "acp" to the `opencode` binary. This argument is specific to how the `opencode` binary exposes its ACP functionality.
*   **`provider = "opencode"`**: Sets the "opencode" provider (defined in `acp_providers`) as the default AI provider for `avante.nvim`. This ensures that `avante.nvim` will use the `opencode` agent for its AI interactions.
*   **`windows = { width = 40 }`**: Sets the default width of `avante.nvim`'s sidebar or other windows to 40 characters, optimizing for readability.

### 4.3. Integration with `lazy.nvim`

Since the `avante.lua` file is placed in the `config/nvim/lua/plugins/` directory, and the `lazy.nvim` configuration (in `config/nvim/lua/core/lazy.lua`) includes `import = "plugins"`, this new configuration file will be automatically discovered and loaded by `lazy.nvim` when Neovim starts.

## 5. Verification

To verify the integration, the user should:

1.  Restart Neovim.
2.  Attempt to use `avante.nvim`'s AI features (e.g., `:AvanteAsk` command).
3.  Confirm that `avante.nvim` interacts with the `opencode` agent as expected. The `opencode` agent will then handle the underlying communication with the Google Gemini API.

## 6. Future Considerations

*   **Error Handling**: If the `opencode` binary is not in PATH or fails to execute, `avante.nvim`'s behavior should be observed to understand how it handles such errors.
*   **Custom Arguments/Environment Variables**: If more granular control over the `opencode` binary's behavior is needed in the future (e.g., specifying a different model or project), the `args` or `env` tables within the `opencode` ACP provider definition can be extended.
*   **`AGENTS.md` Content**: Develop a comprehensive `AGENTS.md` file in the project root to guide the `opencode` agent's responses within `avante.nvim`.
