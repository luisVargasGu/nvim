require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "gofmt" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		yaml = { "yamlfmt" },
		yml = { "yamlfmt" },
		c = { "clang-format" },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		sass = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
	},
})
