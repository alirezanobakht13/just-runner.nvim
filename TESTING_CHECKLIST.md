# Testing Checklist for just-runner.nvim

Use this checklist to verify the plugin works correctly before release.

## Prerequisites Check
- [ ] Neovim version 0.10.0 or higher installed
- [ ] `just` command-line tool installed and in PATH
- [ ] At least one picker available (snacks.nvim or telescope.nvim)

## Installation Tests

### Lazy.nvim
- [ ] Plugin installs without errors
- [ ] Dependencies resolve correctly
- [ ] Setup function runs successfully
- [ ] Keybindings register properly

### Packer.nvim
- [ ] Plugin installs via `:PackerSync`
- [ ] No dependency conflicts
- [ ] Config runs on startup

### Manual Installation
- [ ] Works with `nvim -u minimal_init.lua`
- [ ] Plugin loads from local directory

## Core Functionality Tests

### Justfile Discovery
- [ ] Finds justfile in current directory
- [ ] Finds justfile in parent directory
- [ ] Handles missing justfile gracefully
- [ ] Recognizes "justfile", "Justfile", ".justfile"

### Justfile Parsing
- [ ] Parses simple targets (no parameters)
- [ ] Parses targets with required parameters
- [ ] Parses targets with optional parameters
- [ ] Parses targets with variadic parameters (*args)
- [ ] Ignores comments
- [ ] Handles empty lines
- [ ] Extracts all targets correctly

### Command Execution
- [ ] `:JustRun` opens picker
- [ ] `:Just` opens picker (alias works)
- [ ] Simple targets execute immediately
- [ ] Targets with params prompt for input
- [ ] Commands run in correct directory
- [ ] Exit codes detected correctly
- [ ] Terminal opens in configured position

### Picker Integration

#### Snacks.nvim
- [ ] Picker opens correctly
- [ ] Targets display properly
- [ ] Search/filter works
- [ ] Selection executes target
- [ ] Canceling closes picker
- [ ] Fallback to vim.ui.select if snacks missing

#### Telescope.nvim
- [ ] Picker opens correctly
- [ ] Fuzzy finding works
- [ ] Preview shows target info
- [ ] Selection executes target
- [ ] Error shown if telescope missing

### Window Management

#### Bottom Position
- [ ] Opens at bottom of screen
- [ ] Respects height configuration
- [ ] Doesn't block current buffer
- [ ] Can be closed with :q

#### Right Position
- [ ] Opens on right side
- [ ] Respects width configuration
- [ ] Splits properly
- [ ] Can be closed with :q

#### Float Position
- [ ] Opens as centered float
- [ ] Respects width/height config
- [ ] Has border
- [ ] Can be closed with :q

### Auto-Close Behavior
- [ ] Closes after success (when enabled)
- [ ] Stays open after error (when enabled)
- [ ] Respects pause_before_close delay
- [ ] Doesn't close if waiting for input
- [ ] Manual close always works

### Parameter Input
- [ ] Prompts for required parameters
- [ ] Shows parameter names in prompt
- [ ] Empty input cancels execution
- [ ] Passes parameters to command correctly
- [ ] Handles spaces in parameters
- [ ] Handles special characters

## Configuration Tests

### Default Configuration
- [ ] Loads with no setup() call
- [ ] Defaults are sensible
- [ ] All options have default values

### Custom Configuration
- [ ] picker option changes picker
- [ ] window_position changes position
- [ ] close_on_success works
- [ ] close_on_error works
- [ ] pause_before_close adjusts delay
- [ ] window_size changes dimensions

### Configuration Validation
- [ ] Invalid picker value handled
- [ ] Invalid position value handled
- [ ] Invalid timeout handled
- [ ] Invalid size values handled

## Error Handling Tests
- [ ] No justfile: clear error message
- [ ] Empty justfile: clear message
- [ ] Invalid justfile syntax: graceful handling
- [ ] Missing picker: fallback or error
- [ ] Command not found: error shown
- [ ] Permission denied: error shown
- [ ] just not installed: clear error

## Edge Cases
- [ ] Very long target names
- [ ] Targets with special characters
- [ ] Multiple spaces in parameters
- [ ] Very deep directory nesting
- [ ] Justfile with 100+ targets
- [ ] Concurrent executions
- [ ] Rapid picker open/close
- [ ] Terminal resize during execution

## Cross-Platform Tests

### Windows
- [ ] Plugin loads correctly
- [ ] Commands execute properly
- [ ] Path handling works
- [ ] PowerShell integration works
- [ ] Line endings handled correctly

### Linux
- [ ] Plugin loads correctly
- [ ] Commands execute properly
- [ ] Bash/sh integration works
- [ ] Path separators correct

### macOS
- [ ] Plugin loads correctly
- [ ] Commands execute properly
- [ ] Zsh integration works
- [ ] Path separators correct

## Performance Tests
- [ ] Loads in < 10ms
- [ ] Parses 100-line justfile in < 50ms
- [ ] Picker opens quickly
- [ ] No memory leaks after 100 runs
- [ ] CPU usage reasonable during execution

## Documentation Tests
- [ ] README.md is accurate
- [ ] QUICKSTART.md works for new users
- [ ] :help just-runner displays correctly
- [ ] All examples work as described
- [ ] Installation instructions accurate
- [ ] Configuration examples work

## Integration Tests

### With lazy.nvim
- [ ] Lazy loads correctly
- [ ] Keys config works
- [ ] Dependencies load first
- [ ] No conflicts with other plugins

### With Telescope
- [ ] No conflicts
- [ ] Telescope mappings work
- [ ] Styles match theme

### With Snacks
- [ ] No conflicts
- [ ] Snacks picker styles work
- [ ] Matches snacks theme

## Regression Tests
- [ ] Re-run all tests after any fix
- [ ] Verify no new issues introduced
- [ ] Check all features still work

## Pre-Release Checklist
- [ ] All tests above pass
- [ ] Documentation reviewed
- [ ] CHANGELOG.md updated
- [ ] Version number updated
- [ ] No debug print statements
- [ ] Code formatted consistently
- [ ] Comments accurate
- [ ] LICENSE file present
- [ ] README badges work
- [ ] Screenshots up to date (if any)

## Post-Release Verification
- [ ] GitHub release created
- [ ] Tag pushed correctly
- [ ] Installation from GitHub works
- [ ] lazy.nvim can install it
- [ ] packer.nvim can install it
- [ ] Issues template created
- [ ] PR template created
- [ ] Contributing guidelines clear

---

**Notes:**
- Check issues as you test them
- Document any failures
- Re-test after fixes
- Keep this updated for future releases
