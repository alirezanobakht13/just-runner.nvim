# Better Lazy.nvim Configuration

The issue with your current config is that `keys` causes lazy loading, but the command isn't registered until the plugin loads.

## Option 1: Load on VimEnter (Recommended)

```lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VimEnter", -- Load when Neovim starts
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

## Option 2: Use cmd Instead of Keys (Better for Lazy Loading)

```lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = { "JustRun", "Just" }, -- Load when command is used
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

## Option 3: Use Lua Function in Keys (Most Reliable)

```lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { 
      "<leader>j", 
      function() 
        require("just-runner").run() 
      end, 
      desc = "Just Run" 
    },
  },
}
```

## Option 4: Always Load (No Lazy Loading)

```lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = { "folke/snacks.nvim" },
  lazy = false, -- Always load immediately
  config = function()
    require("just-runner").setup()
  end,
  keys = {
    { "<leader>j", "<cmd>JustRun<cr>", desc = "Just Run" },
  },
}
```

## Recommended: Option 3 (Lua Function)

This is the most reliable because:
- Plugin loads only when you press `<leader>j`
- No dependency on command existing first
- Directly calls the Lua function
- Still benefits from lazy loading
- Works even if there's no justfile

**Replace your current config with:**

```lua
return {
  dir = "D:/just-runner.nvim",
  name = "just-runner.nvim",
  dependencies = { 
    "folke/snacks.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    require("just-runner").setup({
      which_key = {
        enabled = true,
        keymap = "<leader>j",
        icon = "󰐊",
        desc = "Just Run",
      },
    })
  end,
  keys = {
    { 
      "<leader>j", 
      function() 
        require("just-runner").run() 
      end, 
      desc = "Just Run",
      mode = "n",
    },
  },
}
```

This will:
1. ✅ Load plugin when you press `<leader>j`
2. ✅ Work even if no justfile exists (shows notification)
3. ✅ Work even if `just` is not installed (shows notification)
4. ✅ Not break Neovim
5. ✅ Register which-key icon properly
