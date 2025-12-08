return {
  -- Hop.nvim - EasyMotion-like plugin for Neovim
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran",
      })

      -- Keymaps
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      -- Helper function: skip empty lines and jump to next non-empty line
      local function jump_to_non_empty_line(direction)
        local current_line = vim.fn.line(".")
        local total_lines = vim.fn.line("$")
        local target_line = current_line

        if direction == "down" then
          for line = current_line + 1, total_lines do
            if vim.fn.getline(line):match("%S") then
              target_line = line
              break
            end
          end
        else -- up
          for line = current_line - 1, 1, -1 do
            if vim.fn.getline(line):match("%S") then
              target_line = line
              break
            end
          end
        end

        vim.cmd("normal! " .. target_line .. "G^")
      end

      -- Helper function: jump to first non-whitespace char in current line
      local function jump_to_first_non_blank()
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        local first_non_blank = line:match("^%s*()%S")

        if first_non_blank and first_non_blank ~= col then
          vim.cmd("normal! ^")
        end
      end

      -- Custom keymaps
      -- leader j - highlight words after cursor (skip empty lines)
      vim.keymap.set("n", "<leader>j", function()
        local current_line = vim.fn.getline(".")
        if not current_line:match("%S") then
          jump_to_non_empty_line("down")
        end
        hop.hint_words({ direction = directions.AFTER_CURSOR })
      end, { desc = "Hop word after cursor" })

      -- leader k - highlight words before cursor (skip empty lines)
      vim.keymap.set("n", "<leader>k", function()
        local current_line = vim.fn.getline(".")
        if not current_line:match("%S") then
          jump_to_non_empty_line("up")
        end
        hop.hint_words({ direction = directions.BEFORE_CURSOR })
      end, { desc = "Hop word before cursor" })

      -- leader l - jump to char forward in current line (or first non-blank if empty)
      vim.keymap.set("n", "<leader>l", function()
        local current_line = vim.fn.getline(".")
        if not current_line:match("%S") then
          jump_to_non_empty_line("down")
        end
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { desc = "Hop to char forward in line" })

      -- leader h - jump to char backward in current line (or first non-blank if empty)
      vim.keymap.set("n", "<leader>h", function()
        local current_line = vim.fn.getline(".")
        if not current_line:match("%S") then
          jump_to_non_empty_line("up")
        end
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { desc = "Hop to char backward in line" })

      -- Visual mode
      vim.keymap.set("v", "<leader>j", function()
        hop.hint_words({ direction = directions.AFTER_CURSOR })
      end, { desc = "Hop word after cursor" })

      vim.keymap.set("v", "<leader>k", function()
        hop.hint_words({ direction = directions.BEFORE_CURSOR })
      end, { desc = "Hop word before cursor" })

      vim.keymap.set("v", "<leader>l", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { desc = "Hop to char forward in line" })

      vim.keymap.set("v", "<leader>h", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { desc = "Hop to char backward in line" })

      -- Normal and operator-pending mode mappings for f/t that use hop
      for _, mode in ipairs({ "n", "x", "o" }) do
        vim.keymap.set(mode, "f", function()
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end, { desc = "Hop to char forward" })

        vim.keymap.set(mode, "F", function()
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end, { desc = "Hop to char backward" })

        vim.keymap.set(mode, "t", function()
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end, { desc = "Hop until char" })

        vim.keymap.set(mode, "T", function()
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end, { desc = "Hop until char backward" })
      end
    end,
  },
}
