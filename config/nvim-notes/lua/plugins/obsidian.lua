local knowledge_path = vim.fn.expand("~/Documents/obsidian/knowledge")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "knowledge",
        path = knowledge_path,
      },
      {
        name = "current",
        path = function()
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL,
          new_notes_location = "current_dir",
          templates = {
            folder = vim.NIL,
          },
          frontmatter = {
            enabled = false,
          },
        },
      },
    },

    notes_subdir = "00 - Fleeting",

    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "daily.md",
    },

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
    },

    completion = {
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",

    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,

    link = {
      style = "markdown",
    },

    image_name_func = function()
      return string.format("%s-", os.time())
    end,

    frontmatter = {
      enabled = false,
    },

    picker = {
      name = "snacks.pick",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },

    search = {
      sort_by = "modified",
      sort_reversed = true,
    },

    open_notes_in = "current",

    ui = {
      enable = false,
    },

    attachments = {
      folder = "assets/imgs",
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },
}
