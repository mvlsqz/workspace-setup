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
  },
}
