local M = {}

function M.status()
  print("\n=== LSP Status ===")
  print("Gopls executable: " .. vim.fn.exepath("gopls"))
  
  local clients = vim.lsp.get_clients()
  print("Total LSP clients: " .. #clients)
  
  for _, client in ipairs(clients) do
    print(string.format("  - %s (id: %d)", client.name, client.id))
  end
  
  print("Current buffer: " .. vim.fn.bufname(0))
  print("Current filetype: " .. vim.bo.filetype)
  
  -- Check if current buffer is attached to any LSP client
  local bufnr = vim.api.nvim_get_current_buf()
  local attached_clients = vim.lsp.get_clients({ bufnr = bufnr })
  print("Attached clients for current buffer: " .. #attached_clients)
  for _, client in ipairs(attached_clients) do
    print(string.format("  - %s (id: %d)", client.name, client.id))
  end
  
  print("")
end

function M.start_gopls()
  print("Attempting to start gopls...")
  vim.lsp.enable("gopls", { bufnr = 0 })
  print("Done")
end

return M
