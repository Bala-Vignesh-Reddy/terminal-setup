return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { "clangd", "lua_ls", "marksman", "denols" },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })
          end,
          ["lua_ls"] = function()
            require('lspconfig').lua_ls.setup({
              settings = {
                Lua = {
                  diagnostics = { globals = { 'vim' } },
                }
              }
            })
          end,
        }
      })
    end,
  }
}

