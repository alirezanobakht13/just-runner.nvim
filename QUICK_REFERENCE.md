# just-runner.nvim - Quick Reference

## Installation
```lua
-- lazy.nvim
{ "your-username/just-runner.nvim", dependencies = { "folke/snacks.nvim" } }
```

## Commands
- `:JustRun` - Open target picker
- `:Just` - Alias for JustRun

## Keybindings
```lua
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>")
```

## Configuration
```lua
require("just-runner").setup({
  picker = "snacks",              -- "snacks" or "telescope"
  window_position = "bottom",     -- "bottom", "right", "float"
  close_on_success = true,        -- Auto-close on success
  close_on_error = false,         -- Keep open on error
  pause_before_close = 2000,      -- Wait time (ms)
  window_size = {
    width = 0.8,                  -- 80% width
    height = 0.4,                 -- 40% height
  },
})
```

## Justfile Syntax Examples
```just
# Simple target
build:
    cargo build

# With required parameter
deploy env:
    ./deploy.sh {{env}}

# With optional parameter
serve port="8080":
    python -m http.server {{port}}

# With variadic arguments
run *args:
    cargo run -- {{args}}
```

## Workflow
1. Run `:JustRun` or press `<leader>j`
2. Select target from picker
3. Enter parameters if prompted
4. Command runs in terminal
5. Terminal auto-closes (if configured)

## Troubleshooting
- **No justfile found**: Create `justfile` in project root
- **Picker not found**: Install snacks.nvim or telescope.nvim
- **Terminal won't close**: Check `close_on_success`/`close_on_error` settings

## Help
- `:help just-runner` - Vim help
- See README.md for full documentation
