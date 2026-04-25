# Integrating OpenCode Agent with avante.nvim as ACP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** To configure `avante.nvim` to use the `opencode` agent as its AI Code Partner (ACP), allowing `avante.nvim` to delegate AI interactions to the `opencode` binary.

**Architecture:** A new Lua configuration file (`avante.lua`) will be created within the `nvim/lua/plugins` directory. This file will configure `avante.nvim` to define "opencode" as a custom ACP provider, specifying the `opencode` binary and its arguments. This configuration will be automatically loaded by `lazy.nvim`.

**Tech Stack:** Neovim, `avante.nvim`, `lazy.nvim`, Lua, `opencode` binary.

---

### Task 1: Confirm `avante.lua` Configuration File

**Files:**
- Create: `/Users/io/Documents/Forks/workspace-setup/config/nvim/lua/plugins/avante.lua`

- [ ] **Step 1: Confirm `avante.lua` content**

    Verify that the file `/Users/io/Documents/Forks/workspace-setup/config/nvim/lua/plugins/avante.lua` exists and contains the following:

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

- [ ] **Step 2: Commit**

    ```bash
    git add /Users/io/Documents/Forks/workspace-setup/config/nvim/lua/plugins/avante.lua
    git commit -m "feat: configure avante.nvim to use opencode as ACP provider"
    ```

### Task 2: Verify `snacks.nvim` Installation

**Goal:** Ensure `snacks.nvim` is correctly installed, as `avante.nvim` is configured to use it as an input provider.

- [ ] **Step 1: Check `lazy.nvim` configuration for `snacks.nvim`**

    Open `/Users/io/Documents/Forks/workspace-setup/config/nvim/lua/core/lazy.lua` and verify that `folke/snacks.nvim` is listed in the `dependencies` of `avante.nvim` or as a standalone plugin.

    ```lua
    -- Example within avante.nvim dependencies (or similar standalone setup)
    {
      "yetone/avante.nvim",
      -- ...
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } }, -- This line (or similar)
        -- ...
      },
      -- ...
    }
    ```

- [ ] **Step 2: If `snacks.nvim` is not found, add it**

    If `folke/snacks.nvim` is not configured, add it to your `lazy.nvim` setup, for example, within the `avante.nvim` dependencies or as a separate plugin in your `plugins` directory.

- [ ] **Step 3: Commit (if changes were made)**

    ```bash
    git add /Users/io/Documents/Forks/workspace-setup/config/nvim/lua/core/lazy.lua # Or path to your plugin configuration
    git commit -m "fix: ensure snacks.nvim is installed for avante.nvim input provider"
    ```

### Task 3: Verify `opencode` Binary Accessibility

**Goal:** Ensure the `opencode` binary is executable and discoverable in the system's PATH.

- [ ] **Step 1: Check `opencode` binary in PATH**

    Open your terminal and run the following command:

    ```bash
    which opencode
    ```
    Expected: The command should return the full path to the `opencode` executable (e.g., `/usr/local/bin/opencode`).

- [ ] **Step 2: If `opencode` is not found, install it or add it to PATH**

    If `which opencode` does not return a path, ensure the `opencode` binary is installed and its location is added to your system's PATH environment variable.

- [ ] **Step 3: Commit (if changes were made to shell configuration)**

    If you modified your shell configuration (e.g., `.bashrc`, `.zshrc`) to add `opencode` to PATH, commit those changes.

    ```bash
    git add ~/.zshrc # Or your shell config file
    git commit -m "chore: add opencode binary to system PATH"
    ```

### Task 4: Restart Neovim and Initial Verification

**Goal:** Load the new `avante.nvim` configuration and perform a basic check to confirm `opencode` ACP is active.

- [ ] **Step 1: Restart Neovim**

    Close all instances of Neovim and reopen it. This will force `lazy.nvim` to load the updated configurations.

- [ ] **Step 2: Check `avante.nvim` provider**

    Inside Neovim, open a Lua file and try to invoke `avante.nvim`'s features. For example, type `:AvanteAsk` and see if the input prompt appears and if there are any errors in the Neovim messages (check with `:messages`).

    Expected: The `avante.nvim` input prompt should appear, and no immediate errors related to the `opencode` provider should be shown.

- [ ] **Step 3: Test AI interaction**

    Enter a simple query (e.g., "Explain this code") into the `avante.nvim` input prompt.

    Expected: `avante.nvim` should send the query to the `opencode` agent, and you should receive a response. Observe your terminal where `opencode` is running; you might see output indicating interaction.

- [ ] **Step 4: Resolve any errors**

    If any errors occur during this initial verification, check:
    *   Neovim `:messages` for any `avante.nvim` or `opencode` related errors.
    *   Your `opencode` agent's logs or terminal output for any issues on its side.
    *   The `avante.lua` configuration for any typos.

---

Plan complete and saved to `docs/superpowers/plans/2026-04-25-avante-opencode-acp-design.md`. Two execution options:

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?