-- ============================================================================
-- MULTI-CURSOR: vim-visual-multi
-- ============================================================================

return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      -- Use default mappings
      -- Ctrl-N to start multi-cursor
      -- Ctrl-Down/Ctrl-Up to create cursors vertically
      -- n/N to get next/previous occurrence
      -- [/] to select next/previous cursor
      -- q to skip current and get next occurrence
      -- Q to remove current cursor/selection
      
      -- Customize VM leader key (optional, default is \\)
      -- vim.g.VM_leader = '\\'
      
      -- Theme
      vim.g.VM_theme = "iceblue"
      
      -- Additional settings
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
      }
    end,
  },
}
