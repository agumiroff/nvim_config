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

-- Clear search highlighting and close quickfix/location list
keymap("n", "<Esc>", function()
  vim.cmd("noh")
  -- Close quickfix if open
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
  end
  -- Close location list if open
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
  end
end, opts)

-- Undo and Redo
keymap("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo" })

-- Half-page scrolling with Shift+J and Shift+K
keymap("n", "J", "<C-d>", opts)  -- Scroll down half page
keymap("n", "K", "<C-u>", opts)  -- Scroll up half page

-- Save and quit shortcuts
keymap("n", "<C-s>", ":w<CR>", opts)
-- Buffer stack for each window
local buffer_stack = {}

local function get_window_id()
  return vim.fn.win_getid()
end

local function push_buffer()
  local win_id = get_window_id()
  local bufnr = vim.api.nvim_get_current_buf()
  
  if buffer_stack[win_id] == nil then
    buffer_stack[win_id] = {}
  end
  
  -- Avoid duplicate consecutive buffers in stack
  if buffer_stack[win_id][#buffer_stack[win_id]] ~= bufnr then
    table.insert(buffer_stack[win_id], bufnr)
  end
end

local function pop_buffer()
  local win_id = get_window_id()
  
  if buffer_stack[win_id] == nil or #buffer_stack[win_id] == 0 then
    return nil
  end
  
  return table.remove(buffer_stack[win_id])
end

-- Track buffer changes
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    push_buffer()
  end,
})

keymap("n", "<leader>q", function()
  -- Close current buffer, but keep the window open and show previous buffer from stack
  local bufnr = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  
  if #buffers > 1 then
    -- Pop current buffer from stack
    pop_buffer()
    -- Get the previous buffer from stack
    local prev_buf = pop_buffer()
    
    if prev_buf and vim.fn.bufexists(prev_buf) == 1 then
      vim.cmd("buffer " .. prev_buf)
    else
      -- If no previous buffer in stack, use alternate
      vim.cmd("buffer #")
    end
    
    vim.cmd("bd " .. bufnr)
  else
    -- If this is the last buffer, close it
    vim.cmd("bd")
  end
end, { noremap = true, silent = true, desc = "Close buffer" })
keymap("n", "<leader>z", ":close<CR>", { noremap = true, silent = true, desc = "Close window/split" })
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

-- Jump to last position in jump list
keymap("n", "<leader>ll", "<C-o>", { noremap = true, silent = true, desc = "Jump to last position" })

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

-- Ripgrep search
keymap("n", "<leader>gg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Ripgrep search" })

-- Go to definition
keymap("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })

-- Go to implementation
keymap("n", "<leader>gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "Go to implementation" })

-- List references
keymap("n", "<leader>gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "List references" })

-- Hover info
keymap("n", "<leader>gl", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover info" })

-- Signature help
keymap("n", "<leader>gs", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "Signature help" })

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
-- DEBUG
-- ============================================================================

keymap("n", "<leader>ld", function()
  local debug_lsp = require("config.debug_lsp")
  debug_lsp.status()
end, { noremap = true, silent = false, desc = "Debug LSP" })

keymap("n", "<leader>ls", function()
  local debug_lsp = require("config.debug_lsp")
  debug_lsp.start_gopls()
end, { noremap = true, silent = false, desc = "Start gopls" })

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
