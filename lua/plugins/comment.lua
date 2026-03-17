-- ============================================================================
-- COMMENT: Code commenting with gcc/gbc
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
        mappings = {
          basic = true,
          extra = false,
        },
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },
}
