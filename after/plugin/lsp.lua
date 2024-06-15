local lsp_zero = require('lsp-zero')

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

lspconfig.html.setup {
	capabilities = capabilities,
}
lspconfig.cssls.setup {
	capabilities = capabilities,
}

lspconfig.angularls.setup {}

lspconfig.ocamllsp.setup({
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
			if vim.fn.exists(":TypescriptFixAll") then
				vim.cmd("TypescriptFixAll!")
				vim.cmd("TypescriptRemoveUnused!")
				vim.cmd("TypescriptOrganizeImports!")
				return nil
			end
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

require('sonarlint').setup({
	server = {
		cmd = {
			'sonarlint-language-server',
			-- Ensure that sonarlint-language-server uses stdio channel
			'-stdio',
			'-analyzers',
			-- paths to the analyzers you need, using those for python and java in this example
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
		},
		settings = {
			-- The default for sonarlint is {}, this is just an example
			sonarlint = {
				rules = {
					['typescript:S101'] = { level = 'on', parameters = { format = '^[A-Z][a-zA-Z0-9]*$' } },
					['typescript:S103'] = { level = 'on', parameters = { maximumLineLength = 180 } },
					['typescript:S106'] = { level = 'on' },
					['typescript:S107'] = { level = 'on', parameters = { maximumFunctionParameters = 7 } }
				}
			}
		}
	},
	filetypes = {
		'javascript', 'javascriptreact', 'javascript.jsx',
		'typescript', 'typescriptreact', 'typescript.tsx',
	},
	auto_attach = true,
})

