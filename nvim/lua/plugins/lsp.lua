vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    only_current_line = true,
  },
  signs = false,
  underline = true,
})

return {
  {
    'saghen/blink.cmp',
    version = '1.*',

    opts = {
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono'
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    }
  },
  {
    "neovim/nvim-lspconfig",

    config = function()
      vim.lsp.enable({ "lua_ls", "ts_ls" })
    end
  },
}
