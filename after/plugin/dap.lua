require("nvim-dap-virtual-text").setup()

-- Set keymaps to control the debugger
vim.keymap.set('n', '<leader>ui', require 'dapui'.toggle)
vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
  require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
	require("dap").configurations[language] = {
		{
			type = 'pwa-node',
			request = 'launch',
			name = 'Launch Current File (pwa-node)',
			cwd = "${workspaceFolder}", -- vim.fn.getcwd(),
			args = { '${file}' },
			sourceMaps = true,
			protocol = 'inspector',
		},
		{
			type = 'pwa-node',
			request = 'launch',
			name = 'Launch Current File (Typescript)',
			cwd = "${workspaceFolder}",
			runtimeArgs = { '--loader=ts-node/esm' },
			program = "${file}",
			runtimeExecutable = 'node',
			-- args = { '${file}' },
			sourceMaps = true,
			protocol = 'inspector',
			outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require 'dap.utils'.pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Start Chrome with \"localhost\"",
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
		}
	}
end

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")


dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}", --let both ports be the same for now...
	executable = {
		command = "js-debug-adapte",
		-- -- 💀 Make sure to update this path to point to your installation
		args = { vim.fn.stdpath('data') .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
		-- command = "js-debug-adapter",
		-- args = { "${port}" },
	},
}

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end
