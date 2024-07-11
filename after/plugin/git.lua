require('gitsigns').setup {
	signs = {
		add          = { text = '▎' },
		change       = { text = '▎' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signs_staged = {
		add          = { text = '▎' },
		change       = { text = '▎' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end)

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end)
		vim.keymap.set('n', '<leader>gj', function() gitsigns.next_hunk() end, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gk', function() gitsigns.prev_hunk() end, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gl', function() gitsigns.blame_line() end, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gp', function() gitsigns.preview_hunk() end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gr', function() gitsigns.reset_hunk() end, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gR', function() gitsigns.reset_buffer() end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gs', function() gitsigns.stage_buffer() end, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gu', function() gitsigns.undo_stage_hunk() end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>go', function() vim.cmd('Telescope git_status') end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gb', function() vim.cmd('Telescope git_branches') end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gc', function() vim.cmd('Telescope git_commits') end,
			{ noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gd', function() vim.cmd('Gitsigns diffthis HEAD') end,
			{ noremap = true, silent = true })
	end
}
