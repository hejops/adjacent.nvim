local M = {
	opts =  {}
}

M.default_config = {
	level = 1,
	exclude_binary = false,
}

local builtin = require("telescope.builtin")

M.setup = function(opts)
end

M.config = function(opts)
	M.opts = vim.tbl_deep_extend("force", default_config, opts)
end

M.find = function()
	local level = M.opts.level
	local current_buffer_directory = vim.fn.expand("%:h")

	local cmd = { "find", ".", "-maxdepth", tostring(level), "-type", "f" }

	if M.opts.exclude_binary then
		-- exclude executable binary files, but still include executable text files
		-- https://unix.stackexchange.com/a/365705
		for _, arg in pairs({ "-exec", "grep", "-I", "-q", ".", "{}", ";", "-print" }) do
			table.insert(cmd, arg)
		end
	end

	builtin.find_files({
		prompt_title = "Adjacent",
		cwd = current_buffer_directory,
		find_command = cmd,
	})
end

return M
