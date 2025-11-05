# 🚀 Quick Start Guide - just-runner.nvim

This is the fastest way to get started with just-runner.nvim!

## Prerequisites

1. **Neovim 0.10.0+**
   ```bash
   nvim --version  # Should show v0.10.0 or higher
   ```

2. **just command-line tool**
   ```bash
   # Windows (via scoop)
   scoop install just
   
   # macOS
   brew install just
   
   # Linux
   cargo install just
   # or use your package manager
   ```

3. **A picker plugin** (choose one):
   - [snacks.nvim](https://github.com/folke/snacks.nvim) - Recommended
   - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Alternative

## Installation (3 minutes)

### Using lazy.nvim (Recommended)

Add this to your Neovim config (`~/.config/nvim/lua/plugins/just-runner.lua` or similar):

```lua
return {
  "your-username/just-runner.nvim",
  dependencies = {
    "folke/snacks.nvim", -- or "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

Restart Neovim, and lazy.nvim will auto-install it.

### Using packer.nvim

Add to your `packer` config:

```lua
use {
  "your-username/just-runner.nvim",
  requires = { "folke/snacks.nvim" },
  config = function()
    require("just-runner").setup()
  end
}
```

Then run `:PackerSync`

### Manual Installation (for testing)

```bash
cd /path/to/this/repo
nvim -u minimal_init.lua
```

## First Use (1 minute)

1. **Create a test justfile** in your project:
   ```just
   # justfile
   
   # Say hello
   hello:
       echo "Hello from just-runner.nvim!"
   
   # Build project
   build:
       echo "Building..."
   ```

2. **Open Neovim** in that directory:
   ```bash
   nvim
   ```

3. **Run the plugin**:
   - Press `<leader>j` (usually `,j` or `\j`)
   - Or type `:JustRun`

4. **Select a target** from the picker:
   - Use arrow keys or type to filter
   - Press Enter to execute

5. **Watch it run!** The command executes in a terminal window.

## Configuration (Optional)

Customize the plugin in your setup call:

```lua
require("just-runner").setup({
  -- Choose your picker
  picker = "snacks",  -- or "telescope"
  
  -- Window position
  window_position = "bottom",  -- or "right" or "float"
  
  -- Auto-close behavior
  close_on_success = true,   -- Close when command succeeds
  close_on_error = false,    -- Keep open on failure
  pause_before_close = 2000, -- Wait 2 seconds before closing
  
  -- Window size (for float and right positions)
  window_size = {
    width = 0.8,   -- 80% of editor width
    height = 0.4,  -- 40% of editor height
  },
})
```

## Common Justfile Patterns

### Simple commands
```just
test:
    npm test

build:
    cargo build
```

### With parameters
```just
deploy env:
    ./deploy.sh {{env}}

run port:
    python server.py --port {{port}}
```

### With default parameters
```just
serve port="8080":
    python -m http.server {{port}}
```

### With variadic arguments
```just
run *args:
    cargo run -- {{args}}
```

When you run these, the plugin will prompt for any required parameters!

## Keybinding Examples

Add these to your Neovim config:

```lua
-- Basic
vim.keymap.set("n", "<leader>j", "<cmd>JustRun<cr>", { desc = "Just Run" })

-- Multiple options
vim.keymap.set("n", "<leader>jr", "<cmd>JustRun<cr>", { desc = "Just Run" })
vim.keymap.set("n", "<leader>jj", "<cmd>Just<cr>", { desc = "Just (alias)" })

-- With which-key.nvim
{
  ["<leader>j"] = {
    name = "+just",
    r = { "<cmd>JustRun<cr>", "Run target" },
    j = { "<cmd>Just<cr>", "Run target (quick)" },
  }
}
```

## Tips & Tricks

1. **Nested justfiles**: The plugin searches parent directories automatically!

2. **Multiple justfiles**: It stops at the first one it finds (working up from current directory)

3. **Failed commands**: Set `close_on_error = false` to keep terminal open for debugging

4. **Interactive commands**: The plugin detects prompts and keeps terminal open

5. **Quick access**: Bind to a single key like `<F5>` for fastest access

## Troubleshooting

### "No justfile found"
- Make sure you have a file named `justfile`, `Justfile`, or `.justfile`
- Check you're in the right directory: `:pwd`

### "Telescope/Snacks not found"
- Install the picker: `:Lazy install snacks.nvim`
- Or switch pickers in setup: `picker = "telescope"`

### Terminal doesn't close
- Normal! It waits for `pause_before_close` milliseconds
- Or the command failed and `close_on_error = false`
- Or the command is waiting for input

### Plugin doesn't load
- Check Neovim version: `nvim --version` (need 0.10.0+)
- Check for errors: `:messages`
- Try minimal config: `nvim -u minimal_init.lua`

## Next Steps

1. ✅ Read the full [README.md](README.md) for detailed documentation
2. 📖 Check `:help just-runner` for Vim help
3. 🔧 Explore [DEVELOPMENT.md](DEVELOPMENT.md) to understand how it works
4. 🤝 See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

## Support

- 📝 File issues on GitHub
- 💬 Ask questions in discussions
- 🌟 Star the repo if you find it useful!

---

**You're all set!** Press `<leader>j` and start running your justfile targets! 🎉
