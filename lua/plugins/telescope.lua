return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },

          file_ignore_patterns = {
            "^%.git/",
            "node_modules",
            "vendor/",
          },

          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-q>"] = function(...)
                actions.send_selected_to_qflist(...)
                actions.open_qflist(...)
              end,

              ["<Esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },

        pickers = {
          find_files = { hidden = true },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = false,
            initial_mode = "normal",
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
              n = {
                ["dd"] = actions.delete_buffer,
                ["x"] = actions.delete_buffer,
              },
            },
          },
        },
      })

      telescope.load_extension("fzf")

      -- KEYMAPS
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>w", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>ll", builtin.lsp_document_symbols, { desc = "Last edits" })
    end,
  },
}

