-- ============================================================================
-- COMMENT: Code commenting with gc/gcc
-- ============================================================================

return {
  {
    "numToStr/comment.nvim",
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = nil,
        post_hook = nil,
      })

      -- Optional: Add keymaps for easier access
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Toggle line comment in normal mode
      keymap("n", "<leader>/", "gcc", opts)

      -- Toggle line comment in visual mode
      keymap("v", "<leader>/", "gc", opts)
    end,
  },
}
