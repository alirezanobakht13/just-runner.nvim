# just-runner.nvim - Development Guide

## Project Structure

```
just-runner.nvim/
├── lua/
│   └── just-runner/
│       └── init.lua          # Main plugin implementation
├── plugin/
│   └── just-runner.lua       # Plugin entry point and commands
├── doc/
│   └── just-runner.txt       # Vim help documentation
├── tests/
│   └── just-runner_spec.lua  # Test suite
├── README.md                 # User-facing documentation
├── CHANGELOG.md              # Version history
├── CONTRIBUTING.md           # Contribution guidelines
├── LICENSE                   # MIT License
├── .gitignore               # Git ignore patterns
├── justfile                 # Example justfile for testing
├── minimal_init.lua         # Minimal config for testing
└── validate.lua             # Quick validation script
```

## Key Features Implemented

✅ **Core Functionality**
- Justfile target discovery and parsing
- Interactive target selection with pickers
- Support for targets with parameters
- Automatic justfile finding in directory tree

✅ **Configuration**
- Multiple picker support (snacks.nvim, telescope.nvim)
- Configurable window positioning (bottom, right, float)
- Auto-close behavior (success/error with pause)
- Customizable window dimensions

✅ **User Interface**
- Clean terminal integration
- Parameter input prompts
- Status notifications
- Graceful fallbacks

✅ **Documentation**
- Comprehensive README
- Vim help documentation
- Code comments
- Usage examples

✅ **Testing**
- Test suite with validation
- Example justfile
- Minimal test configuration

## Technical Details

### Plugin Architecture

1. **Entry Point** (`plugin/just-runner.lua`)
   - Version check (Neovim >= 0.10.0)
   - Command registration (:JustRun, :Just)
   - Load prevention guard

2. **Core Module** (`lua/just-runner/init.lua`)
   - Configuration management
   - Justfile discovery and parsing
   - Picker integration (Telescope/Snacks)
   - Terminal window management
   - Command execution with job control

3. **Key Functions**
   - `setup(opts)` - Configure plugin
   - `run()` - Main entry point
   - `find_justfile()` - Locate justfile
   - `parse_justfile()` - Extract targets
   - `run_target()` - Execute command

### Justfile Parsing

The parser identifies recipe definitions using pattern matching:
- Matches lines: `target params: recipe`
- Extracts target name and parameters
- Filters comments and non-recipe lines
- Supports various justfile naming conventions

### Terminal Management

- Creates terminal buffers with `termopen()`
- Handles job exit codes
- Implements auto-close with configurable delay
- Supports three window positions:
  - **bottom**: Split below (default)
  - **right**: Vertical split right
  - **float**: Centered floating window

### Picker Integration

**Snacks.nvim** (default):
- Lightweight and fast
- Built-in to many modern configs
- Fallback to vim.ui.select if unavailable

**Telescope.nvim**:
- More powerful search/filter
- Popular in the community
- Full fuzzy finding support

## Performance Considerations

- Lazy loading via plugin managers
- Efficient file I/O (single pass parsing)
- Minimal dependencies
- No polling or background processes
- Terminal jobs managed by Neovim core

## Compatibility

- ✅ Neovim 0.10.0+
- ✅ Windows, Linux, macOS
- ✅ lazy.nvim, packer.nvim, vim-plug
- ✅ Works with/without picker plugins

## Testing Workflow

1. **Syntax Check**: `nvim --headless -u NONE -c "set rtp+=." -c "lua require('just-runner')" -c "qa!"`
2. **Run Tests**: `nvim --headless -u NONE -c "set rtp+=." -c "luafile tests/just-runner_spec.lua" -c "qa!"`
3. **Manual Test**: `nvim -u minimal_init.lua`
4. **Validate Config**: `nvim --headless -u NONE -c "set rtp+=." -c "luafile validate.lua" -c "qa!"`

## Future Enhancement Ideas

- [ ] Cache parsed justfiles for performance
- [ ] Support for justfile variables and exports
- [ ] History of recently run targets
- [ ] Custom target ordering/favorites
- [ ] Integration with status line plugins
- [ ] Rich target descriptions from comments
- [ ] Multi-justfile project support
- [ ] Tab completion for parameters

## Code Quality

- **Style**: 2-space indentation, clear naming
- **Comments**: Strategic placement for clarity
- **Error Handling**: Graceful fallbacks and notifications
- **Modularity**: Well-separated concerns
- **Performance**: Optimized for speed and memory

## Release Checklist

- [ ] All tests passing
- [ ] Documentation up to date
- [ ] CHANGELOG.md updated
- [ ] Version bumped appropriately
- [ ] Example configurations tested
- [ ] Works with both pickers
- [ ] Cross-platform validation
- [ ] No breaking changes (or documented)

## Maintenance Notes

- Keep dependencies minimal
- Maintain backward compatibility
- Follow semantic versioning
- Respond to issues promptly
- Welcome community contributions

---

**Created**: 2025-11-05  
**Last Updated**: 2025-11-05  
**Status**: Production Ready ✅
