-- Minimal init.lua example for testing just-runner.nvim
-- Place this in your Neovim config or use with: nvim -u minimal_init.lua

-- Set up package path
vim.cmd([[set runtimepath+=.]])

-- For testing without a plugin manager
local function load_plugin()
  require("just-runner").setup({
    picker = "snacks", -- or "telescope"
    window_position = "bottom",
    close_on_success = true,
    close_on_error = false,
    pause_before_close = 2000,
  })
end

-- Load the plugin
local ok, err = pcall(load_plugin)
if not ok then
  print("Error loading just-runner: " .. tostring(err))
  return
end

-- Set up keybindings
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })
vim.keymap.set("n", "<leader>jr", "<cmd>Just<cr>", { desc = "Just Run (alias)" })

print("just-runner.nvim loaded successfully!")
print("Press <leader>j to run a justfile target")
