return {
  "saghen/blink.cmp",
  version = "*",
  lazy = false,
  opts = {
    keymap = {
      preset = "enter",
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },

    sources = {
      default = {
        "buffer",
        "snippets",
        "path",
      },

      providers = {
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          opts = {
            -- Get words from all open buffers
            get_bufn = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },

        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          opts = {},
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          opts = {
            trailing_slash = true,
          },
        },
      },
    },

    completion = {
      menu = {
        enabled = true,
        auto_show = true,
        draw = {
          columns = {
            { "kind_icon" },
            { "label", gap = 1 },
          },
        },
      },

      documentation = {
        auto_show = false,
      },

      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = false,
    },
  },
}
