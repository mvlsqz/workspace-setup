local knowledge_path = vim.fn.expand("~/Documents/obsidian/knowledge")
local work_path = vim.fn.expand("~/Documents/obsidian/knowledge")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre " .. work_path,
    "BufReadPre " .. knowledge_path,
    "BufNewFile " .. work_path,
    "BufNewFile " .. knowledge_path,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "godlygeek/tabular",
    "preservim/vim-markdown",
    "saghen/blink.cmp",
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
    },
  },
  opts = {
    workspaces = {
      {
        name = "knowledge",
        path = knowledge_path,
      },
      {
        name = "work",
        path = work_path,
      },
    },

    notes_subdir = "00 - Fleeting",

    daily_notes = {
      folder = "05 - Daily",
      date_format = "%A-%B-%d-%Y",
      alias_format = "%B-%-d-%Y",
      template = "daily_template.md",
    },

    templates = {
      folder = "04 - Templates",
      date_format = "%A-%B-%d-%Y",
      alias_format = "%B-%-d-%Y",
      note_template = "concept_template.md",
      daily_note_template = "daily_template.md",
    },

    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",

    ---@param title string|?
    ---@return string
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

    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    preferred_link_style = "markdown",

    ---@return string
    image_name_func = function()
      return string.format("%s-", os.time())
    end,

    disable_frontmatter = false,

    ---@return table
    note_frontmatter_func = function(note)
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url }) -- Mac OS
    end,

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
    sort_by = "modified",
    sort_reversed = true,

    open_notes_in = "current",

    ui = {
      enable = false,
    },

    attachments = {
      img_folder = "assets/imgs", -- This is the default
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },
}
