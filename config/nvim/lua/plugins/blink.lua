return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "saghen/blink.compat",
      lazy = true,
      version = false,
    },
  },
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "markdown", "obsidian", "obsidian_new", "obsidian_tags" },
      providers = {
        markdown = { name = "RenderMarkdown", module = "render-markdown.integ.blink" },
        obsidian = { name = "obsidian", module = "blink.compat.source" },
        obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
        obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
      },
    },
  },

  opts_extend = { "sources.default" },
}
