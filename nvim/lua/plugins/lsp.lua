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
    event = "BufReadPost",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            override_vim_notify = true,
          },
        },
      },
    },
    config = function()
      vim.diagnostic.config({
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          severity_sort = true,
        },
        virtual_text = { spacing = 4, prefix = "󰊠" },
        signs = false,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local opts = { noremap = true, silent = true, buffer = bufnr }

          opts.desc = "lsp references"
          vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

          opts.desc = "Lsp definitions"
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

          opts.desc = "lsp declarations"
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "lsp diagnostics"
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "Inline diagnostics details"
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "previous diagnostic"
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

          opts.desc = "next diagnostic"
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          opts.desc = "Lsp Implementations"
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

          opts.desc = "Symbol Info"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Code Actions"
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Smart Rename"
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Lsp signature help"
          vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
          end, opts)
        end,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local servers = vim.split(os.getenv("LSP_SERVERS") or "", "%s+")
      local enabled = {}
      for _, server in ipairs(servers) do
        if server ~= "" then
          table.insert(enabled, server)
        end
      end
      table.insert(enabled, "nil_ls")
      vim.lsp.enable(enabled)
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        nix = { "nixfmt" },
      },
    },
  },
}
