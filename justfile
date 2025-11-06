# Example justfile for testing just-runner.nvim

set shell := ["powershell.exe", "-NoLogo", "-Command"]

# Aliases for testing
alias b := build
alias t := test
alias c := clean

# Build the project
build:
    echo "Building project..."
    echo "Build complete!"

# Run tests
test:
    echo "Running tests..."
    echo "All tests passed!"

# Run with custom arguments
run *args:
    echo "Running with args: {{args}}"

# Deploy to specified environment
deploy env:
    echo "Deploying to {{env}} environment..."
    echo "Deployment complete!"

# Clean build artifacts
clean:
    echo "Cleaning..."
    echo "Clean complete!"

# Install dependencies
install:
    echo "Installing dependencies..."
    echo "Dependencies installed!"

# Format code
format:
    echo "Formatting code..."
    echo "Format complete!"

# Lint code
lint:
    echo "Linting code..."
    echo "No issues found!"

# Start development server
dev port="8080":
    echo "Starting dev server on port {{port}}..."
    echo "Server running!"

# Create a release
release version:
    echo "Creating release {{version}}..."
    echo "Release {{version}} created!"

# Show plugin info
info:
    echo "just-runner.nvim - Run justfile targets from Neovim"
    echo "Version: 1.0.0"
    echo "Repository: https://github.com/your-username/just-runner.nvim"

input:
    $name = Read-Host "Enter your name"
    echo "Hello, $name!"
