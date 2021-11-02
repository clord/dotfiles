-- vim:foldmethod=marker

-- nvim-cmp {{{
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
	sources = cmp.config.sources({
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- }}}

-- treesitter {{{

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    context_commentstring = {
	enable = true
    },
    indent = { enable = true }
})

-- }}}

-- toggleterm {{{

require("toggleterm").setup({ 
    open_mapping = [[<c-\>]],
    direction = 'float'
})

-- }}}

-- gitsigns {{{

require("gitsigns").setup()

-- }}}

-- nvim-tree {{{

vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_add_trailing = 1
-- vim.g.nvim_tree_follow = 1

-- vim.cmd([[highlight NvimTreeGitDirty guifg=]] .. vim.g.terminal_color_11) -- orange
-- vim.cmd([[highlight NvimTreeGitMerge guifg=]] .. vim.g.terminal_color_9) -- dark red
-- vim.cmd [[highlight link NvimTreeCursorLine CurrentWord]]
-- vim.cmd [[highlight link NvimTreeFolderName NONE]]
-- vim.cmd [[highlight link NvimTreeEmptyFolderName NONE]]
-- vim.cmd([[highlight NvimTreeFolderName guifg=]] .. vim.g.terminal_color_4) -- blue
-- vim.cmd([[highlight NvimTreeEmptyFolderName guifg=]] .. vim.g.terminal_color_4) -- blue

-- function _G.auto_refresh_nvim_tree()
--   local tree = require "nvim-tree.lib"
--   if _G.nvim_tree_refresh_timer_id and
--       not vim.tbl_isempty(vim.fn.timer_info(_G.nvim_tree_refresh_timer_id)) then
--     return
--   end
--   _G.nvim_tree_refresh_timer_id = vim.fn.timer_start(2000, function(_)
--     if tree.win_open() then
--       tree.refresh_tree()
--     else
--       vim.fn.timer_stop(_G.nvim_tree_refresh_timer_id)
--       _G.nvim_tree_refresh_timer_id = nil
--     end
--   end, { ["repeat"] = -1 })
-- end
-- vim.api.nvim_command [[augroup nvimtree]]
-- vim.api.nvim_command [[autocmd Filetype NvimTree lua auto_refresh_nvim_tree()]]
-- vim.api.nvim_command [[augroup END]]

-- }}}

-- Telescope {{{

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["œ"] = actions.send_selected_to_qflist + actions.open_qflist, -- Alt-q on macOS
			},
			n = {
				["œ"] = actions.send_selected_to_qflist + actions.open_qflist, -- Alt-q on macOS
			},
		},
	},
})

-- }}}

-- lualine {{{

require("lualine").setup({
	options = { theme = "jellybeans" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch" }, { "diff", colored = false } },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
		},
		lualine_y = {
			{
				"encoding",
				condition = function()
					-- when filencoding="" lualine would otherwise report utf-8 anyways
					return vim.bo.fileencoding and #vim.bo.fileencoding > 0 and vim.bo.fileencoding ~= "utf-8"
				end,
			},
			{
				"fileformat",
				condition = function()
					return vim.bo.fileformat ~= "unix"
				end,
			},
			{ "filetype", icons_enabled = false },
		},
		lualine_z = {  },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "nvim-tree" },
})

-- }}}
