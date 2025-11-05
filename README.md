# just-runner.nvim

> [!IMPORTANT]  
> This project is completely vibe coded using copilot-cli with claude-sonnet-4.5 model. my only contributions is writing prompt.md and this sentence (also helping AI to figure out the bugs during implementation!). but it doesn't mean it doesn't work! so far it works as expected. feel free to open issues and I will ask AI to fix them:D

A Neovim plugin for running [justfile](https://github.com/casey/just) targets directly from Neovim with a beautiful picker interface.

## Features

- 🚀 Run justfile targets from within Neovim
- 🎯 Interactive target selection using telescope.nvim or snacks.nvim
- 📝 Support for targets with parameters
- 🪟 Configurable window positioning (bottom, right, float)
- ⚡ Auto-close terminal on success/failure (configurable)
- 🔍 Automatic justfile discovery in current and parent directories
- 🎨 Clean and minimal UI

## Requirements

- Neovim >= 0.10.0
- [just](https://github.com/casey/just) command-line tool
- One of the following pickers (snacks.nvim is recommended):
  - [snacks.nvim](https://github.com/folke/snacks.nvim) (default)
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

**Important:** Use Lua function in keys to avoid loading issues:

```lua
{
  "alirezanobakht13/just-runner.nvim",
  dependencies = {
    "folke/snacks.nvim", -- Recommended (default)
    -- OR use "nvim-telescope/telescope.nvim"
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
    -- Use Lua function, not command string!
    { 
      "<leader>j", 
      function() require("just-runner").run() end, 
      desc = "Just Run",
      mode = "n",
    },
  },
}
```

**Why Lua function?** Using `"<cmd>JustRun<cr>"` can cause issues with lazy loading. The Lua function ensures the plugin loads before executing.

### Alternative: Load on Command

```lua
{
  "alirezanobakht13/just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = { "JustRun", "Just" },
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

## Configuration

Default configuration:

```lua
require("just-runner").setup({
  picker = "snacks", -- Picker to use: "snacks" or "telescope"
  window_position = "bottom", -- Window position: "bottom", "right", or "float"
  close_on_success = true, -- Close terminal after successful execution
  close_on_error = false, -- Close terminal after failed execution
  pause_before_close = 2000, -- Time to wait before closing (milliseconds)
  window_size = {
    width = 0.8, -- Width ratio for float/right windows
    height = 0.4, -- Height ratio for float/bottom windows
  },
})
```

### Configuration Options

- **picker**: Choose between `"snacks"` (default) or `"telescope"` for target selection
- **window_position**:
  - `"bottom"`: Opens terminal at the bottom
  - `"right"`: Opens terminal on the right side
  - `"float"`: Opens terminal in a floating window
- **close_on_success**: Auto-close terminal when command succeeds
- **close_on_error**: Auto-close terminal when command fails
- **pause_before_close**: Time in milliseconds to wait before auto-closing
- **window_size**: Size ratios for terminal window (0.0 to 1.0)

## Usage

### Quick Start

1. **Install `just` command-line tool**:
   ```bash
   # Windows (via scoop)
   scoop install just
   
   # macOS
   brew install just
   
   # Linux
   cargo install just
   ```

2. **Create a justfile** in your project:
   ```just
   # justfile
   
   # Build the project
   build:
       echo "Building..."
   
   # Run tests
   test:
       echo "Testing..."
   ```

3. **Use in Neovim**:
   - Press `<leader>j` or run `:JustRun`
   - Select a target from the picker
   - Done!

### Commands

- `:JustRun [target]` - Run a target (opens picker if no target specified)
- `:Just [target]` - Alias for `:JustRun`
- `:JustRun <Tab>` - Tab completion for target names

### Keymaps

```lua
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })
vim.keymap.set("n", "<leader>jr", "<cmd>JustRun<cr>", { desc = "Just Run" })
```

## Examples

### Example justfile

```just
# Build the project
build:
    cargo build --release

# Run tests
test:
    cargo test

# Run with arguments
run *args:
    cargo run -- {{args}}

# Deploy to environment
deploy env:
    ./deploy.sh {{env}}
```

### Running Targets

- **Simple target**: Select `build` → Runs immediately
- **Target with parameters**: Select `run` → Prompts for arguments → Runs with provided args
- **Target with required params**: Select `deploy` → Prompts for `env` → Runs with specified environment

## Tips

1. **Justfile Discovery**: The plugin searches for `justfile`, `Justfile`, or `.justfile` in the current directory and parent directories.

2. **Parameter Input**: Targets with parameters will prompt for input. The parameter names are shown in the picker for reference.

3. **Terminal Persistence**: If a command prompts for input or you want to keep the terminal open, set `close_on_success = false` and `close_on_error = false`.

4. **Window Positioning**: Try different window positions to find what works best for your workflow.

## Troubleshooting

### "No justfile found"

- Ensure you have a file named `justfile`, `Justfile`, or `.justfile` in your project
- Check that you're in the correct directory or a subdirectory of your project
- The plugin searches up to 20 parent directories

### "just command not found"

- Install just: https://github.com/casey/just
- Make sure it's in your PATH
- Restart Neovim after installation

### "Telescope/Snacks not found"

- Install the picker dependency you've configured
- Or switch to a different picker in the configuration
- Falls back to `vim.ui.select` if no picker is found

### Terminal doesn't close

- Check your `close_on_success` and `close_on_error` settings
- The plugin won't close terminals that are waiting for input

### Plugin freezes or crashes

- Make sure you're using the latest version
- Check `:messages` for error details
- Open an issue on GitHub with the error message

## Local Development

To test the plugin locally before publishing:

```lua
{
  dir = "/path/to/just-runner.nvim",  -- Local path
  name = "just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", function() require("just-runner").run() end, desc = "Just Run" },
  },
}
```

After making changes, reload:
```vim
:lua package.loaded['just-runner'] = nil
:lua require('just-runner').setup()
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details
