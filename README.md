# just-runner.nvim

> [!IMPORTANT]  
> This project is completely vibe coded using copilot-cli and claude-sonnet-4.5. my only contributions is writing prompt.md and this sentence (and helping AI to figure out the bugs during implementation). but it doesn't mean that it doesn't work! it works as expected so far. feel free to open issues and I will ask the AI to help fix them:D

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

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "your-username/just-runner.nvim",
  dependencies = {
    -- Choose one picker:
    "folke/snacks.nvim", -- Recommended (default)
    -- OR
    -- "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("just-runner").setup({
      picker = "snacks", -- or "telescope"
      window_position = "bottom", -- "bottom", "right", or "float"
      close_on_success = true,
      close_on_error = false,
      pause_before_close = 2000, -- milliseconds
      window_size = {
        width = 0.8,
        height = 0.4,
      },
    })
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "your-username/just-runner.nvim",
  requires = {
    "folke/snacks.nvim", -- or "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("just-runner").setup()
  end
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

### Commands

The plugin provides two commands:

- `:JustRun` - Open the picker to select and run a justfile target
- `:Just` - Alias for `:JustRun`

### Keymaps

Add keymaps to your configuration:

```lua
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })
vim.keymap.set("n", "<leader>jr", "<cmd>JustRun<cr>", { desc = "Just Run" })
```

### Example Workflow

1. Open Neovim in a directory with a justfile
2. Press `<leader>j` (or run `:JustRun`)
3. Select a target from the picker
4. If the target requires parameters, enter them when prompted
5. The command runs in a terminal window
6. Terminal auto-closes on success (if configured)

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

### "Telescope/Snacks not found"

- Install the picker dependency you've configured
- Or switch to a different picker in the configuration

### Terminal doesn't close

- Check your `close_on_success` and `close_on_error` settings
- The plugin won't close terminals that are waiting for input

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details
