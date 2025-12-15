-- ============================================================================
-- KEYMAPS
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key is set in init.lua as SPACE

-- ============================================================================
-- GENERAL
-- ============================================================================

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', opts)

-- Clear search highlighting
keymap("n", "<Esc>", ":noh<CR>", opts)

-- Undo and Redo
keymap("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo" })

-- Half-page scrolling with Shift+J and Shift+K
keymap("n", "J", "<C-d>", opts)  -- Scroll down half page
keymap("n", "K", "<C-u>", opts)  -- Scroll up half page

-- Save and quit shortcuts
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("n", "<leader>q", ":bd<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Close all buffers except current
keymap("n", "<leader>x", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "Close all buffers except current" })

-- Buffer list (Telescope) - configured in telescope.lua
keymap("n", "<leader>w", ":Telescope buffers<CR>", { noremap = true, silent = true, desc = "List buffers" })

-- ============================================================================
-- TELESCOPE
-- ============================================================================

-- File search
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })

-- Jump to last change
keymap("n", "<leader>ll", "g;", { noremap = true, silent = true, desc = "Jump to last change" })

-- Jump to last edit in current buffer
keymap("n", "<leader>ac", function()
  local pos = vim.fn.getpos("'.")
  if pos[2] ~= 0 then
    vim.cmd("normal! `.")
  else
    vim.notify("No previous edit in current buffer", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = "Jump to last edit in current buffer" })

-- Jump to last edit in any buffer (global)
keymap("n", "<leader>ag", function()
  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_idx = jumplist[2]
  
  -- Iterate backward through jumplist to find last edit position
  for i = current_idx, 1, -1 do
    local jump = jumps[i]
    if jump.bufnr and jump.bufnr > 0 and vim.fn.bufexists(jump.bufnr) == 1 then
      -- Check if this buffer has been modified or has changelist
      vim.cmd("buffer " .. jump.bufnr)
      vim.fn.setpos(".", {jump.bufnr, jump.lnum, jump.col, 0})
      return
    end
  end
  
  -- If no jump found, try changelist across buffers
  vim.cmd("normal! g;")
end, { noremap = true, silent = true, desc = "Jump to last edit globally" })

-- Grep search
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })

-- Recent files
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })

-- Help tags
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Help tags" })

-- Search in Neovim config folder
keymap("n", "<leader>fn", ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>", { noremap = true, silent = true, desc = "Find in Neovim config" })

-- ============================================================================
-- FILE TREE (NEO-TREE)
-- ============================================================================

-- Toggle floating file tree (reveal current file)
keymap("n", "<leader>e", ":Neotree toggle float reveal<CR>", { noremap = true, silent = true, desc = "Toggle file tree" })

-- ============================================================================
-- LSP NAVIGATION (Go-specific)
-- ============================================================================

-- Search by symbols
keymap("n", "<leader>gg", ":Telescope lsp_document_symbols<CR>", { noremap = true, silent = true, desc = "Search symbols" })

-- Helper function: move to nearest function if not under cursor
local function lsp_action_on_function(action_name, telescope_cmd)
  return function()
    -- Try action at current position
    local params = vim.lsp.util.make_position_params()
    local result = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 1000)
    
    -- If no result, try to find nearest function forward
    if not result or vim.tbl_isempty(result) then
      -- Use treesitter to find next function
      local ok, ts_utils = pcall(require, "nvim-treesitter.textobjects.move")
      if ok then
        ts_utils.goto_next_start("@function.outer")
      end
    end
    
    -- Execute the action
    vim.cmd(telescope_cmd)
  end
end

-- Go to definition (with function fallback)
keymap("n", "<leader>gd", lsp_action_on_function("definition", "Telescope lsp_definitions"), { noremap = true, silent = true, desc = "Go to definition" })

-- Go to implementation (with function fallback)
keymap("n", "<leader>gi", lsp_action_on_function("implementation", "Telescope lsp_implementations"), { noremap = true, silent = true, desc = "Go to implementation" })

-- List references (with function fallback)
keymap("n", "<leader>gr", lsp_action_on_function("references", "Telescope lsp_references"), { noremap = true, silent = true, desc = "List references" })

-- Hover info
keymap("n", "<leader>gl", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover info" })

-- Code actions
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code actions" })

-- Rename symbol
keymap("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename symbol" })

-- Format
keymap("n", "<leader>fm", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format file" })

-- Diagnostics
keymap("n", "<leader>dd", ":Telescope diagnostics<CR>", { noremap = true, silent = true, desc = "Show all diagnostics" })
keymap("n", "<leader>de", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic at cursor" })
keymap("n", "<leader>dy", function()
  local diags = vim.diagnostic.get(0)
  local line = vim.fn.line(".") - 1
  local col = vim.fn.col(".") - 1
  
  local diag_at_cursor = nil
  for _, diag in ipairs(diags) do
    if diag.lnum == line then
      diag_at_cursor = diag
      break
    end
  end
  
  if diag_at_cursor then
    local message = diag_at_cursor.message
    vim.fn.setreg("+", message)
    vim.notify("Diagnostic copied: " .. message, vim.log.levels.INFO)
  else
    vim.notify("No diagnostic at cursor", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Copy diagnostic at cursor" })
keymap("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })

-- ============================================================================
-- GO-SPECIFIC (go.nvim)
-- ============================================================================

-- These will be configured when go.nvim is loaded
-- <leader>gt - go test
-- <leader>gT - go test file
-- <leader>ga - go add tags
-- <leader>gA - go remove tags
-- <leader>gf - go fill struct
-- <leader>ge - go iferr
