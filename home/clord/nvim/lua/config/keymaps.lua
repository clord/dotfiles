-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

map("n", "<C-F>", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)
map("n", "&", "<cmd>Telescope grep_string<cr>", opts)
map("v", "&", "<cmd>Telescope grep_string<cr>", opts)

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw")

-- type // in visual select mode to search selection
map("v", "//", 'y/<C-R>"<CR>')

--
map("v", "<", "<gv")
map("v", ">", ">gv")

-- map ; to resuming last search
map("n", ";", "<cmd>lua require('telescope.builtin').resume(require('telescope.themes').get_dropdown({}))<cr>", opts)

-- fuzzy search in current buffer
vim.keymap.set("n", "<C-s>", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Fuzzily search in current buffer" })

-- Keymap some common typos
