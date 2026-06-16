return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = function()
    local presets = require("markview.presets")

    return {
      hybrid_mode = true,
      preview = {
        enable = true,
        icon_provider = "internal",
      },

      markdown = {
        enable = true,

        headings = {
          enable = true,
          shift_width = 0,

          heading_1 = {
            style = "icon",
            sign = "",
            icon = "◈ ",
            hl = "MarkviewHeading1",
          },
          heading_2 = {
            style = "icon",
            sign = "",
            icon = "◇ ",
            hl = "MarkviewHeading2",
          },
          heading_3 = {
            style = "icon",
            sign = "",
            icon = "◆ ",
            hl = "MarkviewHeading3",
          },
          heading_4 = {
            style = "icon",
            sign = "",
            icon = "▸ ",
            hl = "MarkviewHeading4",
          },
          heading_5 = {
            style = "icon",
            sign = "",
            icon = "▹ ",
            hl = "MarkviewHeading5",
          },
          heading_6 = {
            style = "icon",
            sign = "",
            icon = "▪ ",
            hl = "MarkviewHeading6",
          },
        },

        block_quotes = presets.block_quotes.obsidian,

        code_blocks = {
          enable = true,
          style = "block",
          min_width = 60,
          pad_amount = 2,
          pad_char = " ",
          label_direction = "right",
          border_hl = "MarkviewCode",
          info_hl = "MarkviewCodeInfo",
          sign = true,

          default = {
            block_hl = "MarkviewCode",
            pad_hl = "MarkviewCode",
          },
        },

        tables = {
          enable = true,
          style = "full",
          hl = {
            border = "MarkviewTableBorder",
            header = "MarkviewTableHeader",
          },
        },

        horizontal_rules = {
          enable = true,
          hl = "MarkviewHorizontalRule",
          text = "────────────────────────────────────────",
        },

        list_items = {
          enable = true,
          indent_size = 2,
          shift_width = 2,

          marker_minus = {
            add_padding = false,
            hl = "MarkviewListItemMinus",
            text = "•",
          },
          marker_plus = {
            add_padding = false,
            hl = "MarkviewListItemPlus",
            text = "•",
          },
          marker_star = {
            add_padding = false,
            hl = "MarkviewListItemStar",
            text = "•",
          },
        },
      },

      markdown_inline = {
        enable = true,

        checkboxes = {
          enable = true,

          checked = {
            text = "󰄬",
            hl = "MarkviewCheckboxChecked",
          },
          unchecked = {
            text = "󰄱",
            hl = "MarkviewCheckboxUnchecked",
          },
          pending = {
            text = "󰥔",
            hl = "MarkviewCheckboxPending",
          },
          ["-"] = {
            text = "󰍶",
            hl = "MarkviewCheckboxCancelled",
          },
          [">"] = {
            text = "󰒋",
            hl = "MarkviewCheckboxDeferred",
          },
        },

        inline_codes = {
          enable = true,
          hl = "MarkviewInlineCode",
          corner_left = " ",
          corner_right = " ",
        },

        hyperlinks = {
          enable = true,
          style = "simple",
          icon = "󰌹 ",
          hl = "MarkviewHyperlink",
        },

        images = {
          enable = true,
          icon = "󰋩 ",
          hl = "MarkviewImage",
        },
      },
    }
  end,
}
