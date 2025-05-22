vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)

-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"+d")
vim.keymap.set("v", "<leader>d", "\"+d")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")


-- Set up key mapping for normal mode (formats the whole buffer)
vim.keymap.set("n", "<leader>f", function()
  local pass_formatting_options = false

  if (pass_formatting_options) then
    require('kaushtuk.format-preserve-fold')({
      formatting_options = {
        tabSize = 8,
        insertSpaces = false,
        trimTrailingWhitespace = true
      },
      async = false
    })
  else
    require('kaushtuk.format-preserve-fold')({
      async = false
    })
  end
end, { noremap = true, silent = true })

local send_escape_if_in_visual_mode = function()
    if (vim.api.nvim_get_mode().mode == 'V') then
        vim.api.nvim_input('<ESC>')
    end
end

local do_lsp_format_async = true
if (do_lsp_format_async) then
    -- Set up key mapping for visual mode (formats selected lines)
    vim.keymap.set("v", "<leader>f", function()
        -- Get the range of selected lines
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        -- Format only the selected range
        require('kaushtuk.format-preserve-fold')({
          async = true,
          range = {
            start = { line = start_line - 1, character = 0 },
            ["end"] = { line = end_line, character = 0 }
          },

        })

        -- Exit visual mode and return to normal mode
        send_escape_if_in_visual_mode()
    end, { noremap = true, silent = true })
else
    -- Set up key mapping for visual mode (formats selected lines)
    vim.keymap.set("v", "<leader>f", function()
        -- Get the range of selected lines
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        -- Format only the selected range
        require('kaushtuk.format-preserve-fold')({
          async = false,
          range = {
            start = { line = start_line - 1, character = 0 },
            ["end"] = { line = end_line, character = 0 }
          },

        })

        vim.schedule(function()
            -- Exit visual mode and return to normal mode
            send_escape_if_in_visual_mode()
        end)
    end, { noremap = true, silent = true })
end


vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--vim.keymap.set("n", "<C-r>", "<C-r>")
--vim.keymap.set("x", "<leader>r", "hy:%s/<CR>//gc<left><left><left>")
vim.keymap.set("x", "<leader>r", "y:%s/<C-r>0//gc<Left><Left><left>")

--------------------------------------
--To see the current keymaps current
--------------------------------------
--:nmap
--:vmap
--:imap
--
