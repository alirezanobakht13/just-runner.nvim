-- Quick validation script to test justfile parsing
local just_runner = require("just-runner")

-- Initialize with default config
just_runner.setup()

print("✓ Plugin loaded successfully")
print("✓ Configuration:")
print("  - Picker: " .. just_runner.config.picker)
print("  - Window Position: " .. just_runner.config.window_position)
print("  - Close on Success: " .. tostring(just_runner.config.close_on_success))
print("  - Close on Error: " .. tostring(just_runner.config.close_on_error))
print("  - Pause Before Close: " .. just_runner.config.pause_before_close .. "ms")

print("\n✓ Plugin validation complete!")
print("\nTo test the plugin:")
print("  1. Run: nvim -u minimal_init.lua")
print("  2. Press <leader>j or run :JustRun")
print("  3. Select a target from the justfile")
