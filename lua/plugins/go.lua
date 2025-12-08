-- ============================================================================
-- GO-SPECIFIC PLUGINS: go.nvim, DAP, etc.
-- ============================================================================

return {
  -- go.nvim - Go development tools
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        -- Disable LSP config (we handle it separately)
        lsp_cfg = false,
        lsp_gofumpt = true,
        lsp_on_attach = false,
        
        -- Test settings
        test_runner = "go",
        run_in_floaterm = false,
        
        -- Icons
        icons = { breakpoint = "🔴", currentpos = "🔵" },
        
        -- Diagnostic settings
        diagnostic = {
          hdlr = false,
          underline = true,
          virtual_text = { spacing = 0, prefix = "■" },
          signs = true,
          update_in_insert = false,
        },
        
        -- Code lens
        lsp_codelens = true,
        
        -- Inlay hints
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
        },
        
        -- Auto format and organize imports on save
        lsp_document_formatting = true,
        
        -- Trouble integration
        trouble = false,
        
        -- Test settings
        test_efm = false,
        luasnip = true,
      })

      -- Keymaps for go.nvim
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          
          -- Test commands
          vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Go test" }))
          vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFile<CR>", vim.tbl_extend("force", opts, { desc = "Go test file" }))
          vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Go coverage" }))
          
          -- Code generation
          vim.keymap.set("n", "<leader>ga", "<cmd>GoAddTag<CR>", vim.tbl_extend("force", opts, { desc = "Go add tags" }))
          vim.keymap.set("n", "<leader>gA", "<cmd>GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Go remove tags" }))
          vim.keymap.set("n", "<leader>gf", "<cmd>GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Go fill struct" }))
          vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go if err" }))
          
          -- Module management
          vim.keymap.set("n", "<leader>gm", "<cmd>GoMod tidy<CR>", vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))
          
          -- Code navigation
          vim.keymap.set("n", "<leader>gs", "<cmd>GoFillSwitch<CR>", vim.tbl_extend("force", opts, { desc = "Go fill switch" }))
        end,
      })
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dap-go
      require("dap-go").setup({
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
        },
      })

      -- Setup dap-ui
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 0.33,
            position = "right",
          },
          {
            elements = {
              { id = "repl", size = 0.45 },
              { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
          },
        },
      })

      -- Virtual text for variables
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
      })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps for debugging
      vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Debug continue" })
      vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Debug step into" })
      vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "Debug step over" })
      vim.keymap.set("n", "<leader>dO", "<cmd>DapStepOut<CR>", { desc = "Debug step out" })
      vim.keymap.set("n", "<leader>dr", "<cmd>DapToggleRepl<CR>", { desc = "Debug toggle REPL" })
      vim.keymap.set("n", "<leader>dl", "<cmd>DapShowLog<CR>", { desc = "Debug show log" })
      vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>", { desc = "Debug test" })
      vim.keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Debug UI toggle" })
      vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "Debug terminate" })

      -- Signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "🔵", texthl = "DapStopped", linehl = "debugPC", numhl = "" })
    end,
    ft = { "go" },
  },

  -- gomodifytags - for adding/removing struct tags
  {
    "fatih/vim-go",
    ft = { "go" },
    build = ":GoUpdateBinaries",
    config = function()
      -- Disable most features (we use go.nvim), only use gomodifytags
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_gopls_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_diagnostics_enabled = 0
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_mod_fmt_autosave = 0
      vim.g.go_template_autocreate = 0
    end,
  },
}
