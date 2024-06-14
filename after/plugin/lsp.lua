local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

local lspconfig = require('lspconfig')

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)
require("lspconfig").lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.stdpath "config" .. "/lua"] = true,
				},
			},
		},
	}
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').tsserver.setup {}

require('lspconfig').html.setup {
	capabilities = capabilities,
}
require('lspconfig').cssls.setup {
	capabilities = capabilities,
}

require('lspconfig').angularls.setup {}

require('lspconfig').ocamllsp.setup({
	cmd = { "ocamllsp" },
	filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	capabilities = capabilities
})


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = { 'tsserver', 'html', 'angularls', 'bashls', 'cssls', 'eslint', 'rust_analyzer' },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	}
})

local opts = { noremap = true, silent = true }

local function quickfix()
	vim.lsp.buf.code_action({
		filter = function(a) return a.isPreferred end,
		apply = true
	})
end

vim.keymap.set('n', '<leader>qf', quickfix, opts)


require("nvim-dap-virtual-text").setup()

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

vim.keymap.set('n', '<leader>ui', require 'dapui'.toggle)
