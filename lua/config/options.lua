-- ============================================================================
-- NEOVIM OPTIONS
-- ============================================================================

local opt = vim.opt

-- General
opt.mouse = "a"                     -- Enable mouse support
opt.clipboard = "unnamedplus"       -- Use system clipboard
opt.swapfile = false                -- Disable swap files
opt.backup = false                  -- Disable backup files
opt.writebackup = false             -- Disable backup before writing
opt.undofile = true                 -- Enable persistent undo
opt.updatetime = 300                -- Faster completion
opt.timeoutlen = 400                -- Time to wait for mapped sequence

-- UI
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.cursorline = true               -- Highlight current line
opt.signcolumn = "yes"              -- Always show sign column
opt.wrap = false                    -- Disable line wrap
opt.scrolloff = 8                   -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8               -- Keep 8 columns left/right of cursor
opt.termguicolors = true            -- True color support
opt.showmode = false                -- Don't show mode (lualine shows it)
opt.pumheight = 10                  -- Popup menu height
opt.splitright = true               -- Vertical splits to the right
opt.splitbelow = true               -- Horizontal splits below

-- Search
opt.ignorecase = true               -- Ignore case in search
opt.smartcase = true                -- Override ignorecase if uppercase used
opt.hlsearch = true                 -- Highlight search results
opt.incsearch = true                -- Incremental search

-- Indentation
opt.expandtab = true                -- Use spaces instead of tabs
opt.shiftwidth = 4                  -- Indent width
opt.tabstop = 4                     -- Tab width
opt.softtabstop = 4                 -- Backspace removes 4 spaces
opt.smartindent = true              -- Smart indentation
opt.autoindent = true               -- Auto indentation

-- Go-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.expandtab = false           -- Go uses tabs
  end,
})

-- Performance
opt.lazyredraw = true               -- Don't redraw during macros

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
