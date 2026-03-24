require('nvim-lspconfig').setup {
  local lsp_zero = require('lsp-zero')
  lsp_zero.extend_lspconfig()

  lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
  end)

  require('mason-lspconfig').setup({
    ensure_installed = {}
    handlers = {
      function(server_name)
	require('lspconfig')[server_name].setup({})
      end,
    }
  })
}
