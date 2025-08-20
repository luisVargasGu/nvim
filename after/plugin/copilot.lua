-- local function should_disable_copilot(dir)
--   return string.match(dir, "/Projects/")
-- end

-- vim.api.nvim_create_autocmd("DirChanged", {
--   callback = function(params)
--     if should_disable_copilot(params.file) then
--       vim.cmd("Copilot disable")
--     end
--   end,
-- })

-- -- for initial directory neovim was started with
-- if should_disable_copilot(vim.loop.cwd()) then
--   vim.cmd("Copilot disable")
-- end
