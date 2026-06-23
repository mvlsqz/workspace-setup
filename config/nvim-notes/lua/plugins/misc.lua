return {
  {
    "LazyVim/LazyVim",
    opts = function()
      local spell_dir = vim.fn.stdpath("config") .. "/spell"
      local spell_file = spell_dir .. "/en.utf-8.add"

      vim.opt.spelllang = "en"
      vim.opt.spelloptions = "camel,noplainbuffer"
      vim.opt.spellfile:append(spell_file)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "gitcommit" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.textwidth = 80
          vim.opt_local.formatoptions:append("t")
        end,
      })

      vim.keymap.set("n", "<leader>sa", function()
        local word = vim.fn.expand("<cword>")
        vim.cmd("normal! zg")
        vim.notify("Added to dictionary: " .. word, vim.log.levels.INFO, { title = "Spell" })
      end, { desc = "Add word to dictionary" })

      vim.keymap.set("n", "<leader>su", function()
        vim.cmd("normal! zug")
        vim.notify("Removed last word from dictionary", vim.log.levels.INFO, { title = "Spell" })
      end, { desc = "Undo last dictionary addition" })

      vim.keymap.set("n", "<leader>st", function()
        vim.opt_local.spell = not vim.opt_local.spell:get()
        vim.notify("Spell check: " .. (vim.opt_local.spell:get() and "ON" or "OFF"), vim.log.levels.INFO, { title = "Spell" })
      end, { desc = "Toggle spell check" })
      vim.keymap.set("n", "<leader>sc", "ciw``<Esc>P", { desc = "Wrap word in backticks" })
      vim.keymap.set("v", "<leader>sc", "c``<Esc>P", { desc = "Wrap selection in backticks" })
      vim.keymap.set("n", "<leader>sb", "ciw****<Esc>hhP", { desc = "Wrap word in bold" })
      vim.keymap.set("v", "<leader>sb", "c****<Esc>hhP", { desc = "Wrap selection in bold" })
      vim.keymap.set("n", "<leader>si", "ciw**<Esc>hP", { desc = "Wrap word in italic" })
      vim.keymap.set("v", "<leader>si", "c**<Esc>hP", { desc = "Wrap selection in italic" })
      vim.keymap.set("n", "<leader>ss", "ciw~~~~<Esc>hhP", { desc = "Wrap word in strikethrough" })
      vim.keymap.set("v", "<leader>ss", "c~~~~<Esc>hhP", { desc = "Wrap selection in strikethrough" })
      vim.keymap.set("n", "<leader>sl", "ciw[]()<Esc>hi", { desc = "Wrap word as link" })
      vim.keymap.set("v", "<leader>sl", "c[]()<Esc>hi", { desc = "Wrap selection as link" })
      vim.keymap.set("n", "<leader>sx", function()
        local line = vim.fn.getline(".")
        if line:match("%[x%]") then
          vim.fn.setline(".", line:gsub("%[x%]", "[ ]"))
        else
          vim.fn.setline(".", line:gsub("%[ %]", "[x]"))
        end
      end, { desc = "Toggle checkbox" })
      vim.keymap.set("n", "<leader>sf", "gggqG", { desc = "Format file to 80 chars" })
    end,
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>s", group = "Spell" },
        { "<leader>z", group = "Zen" },
      },
    },
  },

  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local smart_splits = require("smart-splits")
      vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to lower split" })
      vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to upper split" })
      vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right split" })
    end,
  },

  {
    "nvim-mini/mini.files",
    keys = {
      {
        "<leader>fe",
        function()
          require("mini.files").open(vim.fn.expand("%:p:h"), true)
        end,
        desc = "Open file explorer",
      },
    },
    config = function()
      require("mini.files").setup({
        mappings = {
          go_in = "<CR>",
          go_in_plus = "l",
          go_out = "h",
          go_out_plus = "H",
          show_help = "g?",
          set_cwd = "<C-l>",
          close = "q",
          go_in_reset = "<BS>",
          set_bookmark = "m",
          use_default_mappings = false,
        },
        options = {
          use_as_default_explorer = true,
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 20,
          width_preview = 40,
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "o", function()
            local line = vim.fn.line(".")
            vim.fn.append(line, "")
            vim.fn.cursor(line + 1, 1)
            vim.cmd("startinsert")
          end, { buffer = buf_id, desc = "Create file/dir below" })
          vim.keymap.set("n", "O", function()
            local line = vim.fn.line(".")
            vim.fn.append(line - 1, "")
            vim.fn.cursor(line, 1)
            vim.cmd("startinsert")
          end, { buffer = buf_id, desc = "Create file/dir above" })
          vim.keymap.set("n", "=", function()
            require("mini.files").sync()
          end, { buffer = buf_id, desc = "Apply changes" })
        end,
      })
    end,
  },

  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen,
        default_mappings = true,
        mappings = {
          i = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
            J = {
              J = "<Esc>",
            },
          },
          t = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
        },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local tm = require("mvlsqz")

      vim.keymap.set("n", "<leader>tn", tm.next, { desc = "Next theme" })
      vim.keymap.set("n", "<leader>tp", tm.prev, { desc = "Previous theme" })
      vim.keymap.set("n", "<leader>tt", tm.toggle, { desc = "Toggle light/dark" })
      vim.keymap.set("n", "<leader>ts", tm.select, { desc = "Select theme" })

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        section_separators = { left = "▄", right = "▀" },
        component_separators = { left = "▄", right = "▀" },
      })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "python",
        "go",
        "yaml",
        "json",
        "jsonc",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
    },
  },

  { "hrsh7th/nvim-cmp", enabled = false },
  { "saghen/blink.cmp" },
  { "folke/flash.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },
  { "folke/todo-comments.nvim", enabled = false },
  { "nvim-mini/mini.ai", enabled = false },
  { "nvim-mini/mini.surround", enabled = false },
  { "nvim-mini/mini.pairs", enabled = false },
  { "nvim-mini/mini.diff", enabled = false },
  { "Bilal2453/luvit-meta", enabled = false },
  { "folke/lazydev.nvim", enabled = false },
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
}
