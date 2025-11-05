# Just Runner for Neovim

Write a neovim plugin that allows running justfile command directly from neovim.

## Requirements

- nvim 1.11 or higher
- write in lua
- be able to install using lazy.nvim
- use pickers like telescope.nvim or snack.nvim (this one is defualt) to select justfile targets
- allow adjustable window position.
- close terminal after command is done (optional both for sucessful and failed runs, ajustable pause time before closing). don't close if it prompts for input.
- allow passing arguments to justfile targets (if they require input)

## Development requirements

- follow neovim plugin best practices
- provide clear and concise documentation
- write clean and maintainable code
- include examples of usage
- provide installation instructions
- include comments in the code for clarity
- write tests for the plugin functionality
- ensure compatibility with popular neovim configurations
- use for the development process
- _Make sure to test the plugin thoroughly before release._
- _Make sure to write optimized code for performance._
