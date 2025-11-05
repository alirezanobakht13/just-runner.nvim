# Contributing to just-runner.nvim

Thank you for your interest in contributing to just-runner.nvim!

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/your-username/just-runner.nvim.git
cd just-runner.nvim
```

2. Make sure you have:
   - Neovim >= 0.10.0
   - The `just` command-line tool installed
   - Either telescope.nvim or snacks.nvim for testing

## Testing

Run the test suite:
```bash
nvim --headless -u NONE -c "set rtp+=." -c "luafile tests/just-runner_spec.lua" -c "qa!"
```

Or test manually with the minimal config:
```bash
nvim -u minimal_init.lua
```

## Code Style

- Follow Lua best practices
- Keep functions small and focused
- Add comments for complex logic
- Use meaningful variable names
- Maintain consistent indentation (2 spaces)

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Reporting Issues

When reporting issues, please include:
- Neovim version (`nvim --version`)
- Operating system
- just-runner.nvim configuration
- Steps to reproduce
- Expected vs actual behavior
- Error messages (if any)

## Feature Requests

Feature requests are welcome! Please:
- Check if the feature already exists
- Describe the use case clearly
- Explain how it would benefit users

## Code of Conduct

Be respectful and constructive in all interactions.
