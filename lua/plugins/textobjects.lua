return {
  -- nvim-treesitter-textobjects - расширенные text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- Функции
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",

              -- Классы/структуры
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",

              -- Параметры/аргументы
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
        },
      })

      -- Навигация по функциям и классам
      vim.keymap.set("n", "<leader>fj", function()
        require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")
      end, { desc = "Next function" })

      vim.keymap.set("n", "<leader>fk", function()
        require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")
      end, { desc = "Previous function" })

      vim.keymap.set("n", "<leader>cj", function()
        require("nvim-treesitter.textobjects.move").goto_next_start("@class.outer")
      end, { desc = "Next class" })

      vim.keymap.set("n", "<leader>ck", function()
        require("nvim-treesitter.textobjects.move").goto_previous_start("@class.outer")
      end, { desc = "Previous class" })
    end,
  },

  -- mini.ai - улучшенные text objects для скобок и кавычек
  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          -- cb = фигурные скобки {}
          cb = ai.gen_spec.pair("{", "}", { type = "balanced" }),
          -- qb = квадратные скобки []
          qb = ai.gen_spec.pair("[", "]", { type = "balanced" }),
          -- b = круглые скобки () (оставляем стандартное)
          -- sq = одинарные кавычки '
          sq = ai.gen_spec.pair("'", "'", { type = "balanced" }),
          -- q = двойные кавычки " (стандартное)
        },
      })
    end,
  },
}
