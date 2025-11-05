# Local Testing Guide - just-runner.nvim

This guide shows you how to test the plugin locally with your existing Neovim setup.

## Method 1: Add to Lazy.nvim Config (Recommended)

If you use lazy.nvim, add this to your plugin configuration:

### Option A: Using `dir` (Best for Development)

Add to your `~/.config/nvim/lua/plugins/` or wherever you keep your plugin specs:

```lua
-- ~/.config/nvim/lua/plugins/just-runner.lua
return {
  dir = "D:/just-runner.nvim",  -- Use absolute path to your local directory
  name = "just-runner.nvim",
  dependencies = {
    "folke/snacks.nvim", -- or "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("just-runner").setup({
      picker = "snacks",
      window_position = "bottom",
      close_on_success = true,
      close_on_error = false,
      pause_before_close = 2000,
    })
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
    { "<leader>jr", "<cmd>Just<cr>", desc = "Just Run (alias)" },
  },
}
```

### Option B: Using `dev` Mode

If you have a `dev` path configured in lazy.nvim:

```lua
-- In your lazy setup
require("lazy").setup({
  dev = {
    path = "D:/",  -- Parent directory of your plugin
    patterns = {"just-runner.nvim"},
    fallback = false,
  },
  -- ... other config
})

-- Then in your plugin spec:
{
  "just-runner.nvim",
  dev = true,  -- This tells lazy to use the local version
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("just-runner").setup()
  end,
}
```

## Method 2: Manual Runtime Path

Add this to your init.lua temporarily:

```lua
-- At the top of your init.lua, before loading plugins
vim.opt.runtimepath:append("D:/just-runner.nvim")

-- Then later, after your plugin manager setup:
require("just-runner").setup()

-- Optional: Add keybindings
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })
```

## Method 3: Symlink (Unix-like systems)

Create a symlink in your lazy.nvim data directory:

```bash
# Linux/macOS
ln -s /path/to/just-runner.nvim ~/.local/share/nvim/lazy/just-runner.nvim

# Then add to your config as normal plugin
{
  "just-runner.nvim",
  config = function()
    require("just-runner").setup()
  end,
}
```

## Method 4: Temporary Config Override

Create a test config that loads your existing setup plus the plugin:

```lua
-- test_with_plugins.lua
-- Load your existing config
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init.lua')

-- Add the plugin to runtime path
vim.opt.runtimepath:append("D:/just-runner.nvim")

-- Load and configure the plugin
require("just-runner").setup()

-- Add keybinding
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })

print("just-runner.nvim loaded for testing!")
```

Then run:
```bash
nvim -u test_with_plugins.lua
```

## Recommended Workflow

1. **During Development**: Use Method 1, Option A (lazy.nvim with `dir`)
   - Changes take effect immediately
   - Just reload Neovim or `:Lazy reload just-runner.nvim`

2. **Quick Testing**: Use Method 2 (manual runtimepath)
   - Add/remove easily
   - No config file changes needed

3. **Before Publishing**: Test with actual installation
   - Remove local version
   - Install from GitHub
   - Verify everything works

## Hot Reload During Development

With lazy.nvim and `dir` option:

```vim
:Lazy reload just-runner.nvim  " Reload after code changes
:lua package.loaded['just-runner'] = nil  " Clear cache
:lua require('just-runner').setup()  " Re-initialize
```

## Verifying It Works

After loading, test:

```vim
:JustRun          " Should open picker
:Just             " Should open picker
:lua =require('just-runner').config  " Check configuration
:messages         " Check for any errors
```

## Troubleshooting

### Plugin Not Found
```lua
-- Check if it's in runtime path
:lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))
```

### Functions Not Working
```lua
-- Clear and reload
:lua package.loaded['just-runner'] = nil
:lua require('just-runner').setup()
```

### Keybindings Not Working
```lua
-- Check if command exists
:command JustRun
-- Check if key is mapped
:nmap <leader>j
```

## Example: Complete Local Test Setup

Here's a complete example for lazy.nvim users:

```lua
-- ~/.config/nvim/lua/plugins/just-runner-local.lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("just-runner").setup({
      picker = "snacks",
      window_position = "bottom",
      close_on_success = true,
      close_on_error = false,
      pause_before_close = 2000,
    })
    
    -- Test output
    print("✅ just-runner.nvim loaded from local directory!")
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
    { "<leader>jt", function()
      vim.notify("Testing just-runner.nvim", vim.log.levels.INFO)
      vim.cmd("JustRun")
    end, desc = "Test Just Run" },
  },
}
```

Restart Neovim, and you should see the success message!
