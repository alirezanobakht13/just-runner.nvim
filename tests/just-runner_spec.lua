-- Test suite for just-runner.nvim
-- Run with: nvim --headless -c "luafile tests/just-runner_spec.lua" -c "qa!"

local M = {}

-- Test helpers
local function assert_eq(actual, expected, msg)
  if actual ~= expected then
    error(string.format("%s: expected %s, got %s", msg or "Assertion failed", 
          vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_true(value, msg)
  if not value then
    error(msg or "Expected true, got false")
  end
end

local function assert_not_nil(value, msg)
  if value == nil then
    error(msg or "Expected non-nil value")
  end
end

-- Create a temporary justfile for testing
local function create_test_justfile(content)
  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, "p")
  local justfile_path = tmpdir .. "/justfile"
  local file = io.open(justfile_path, "w")
  file:write(content)
  file:close()
  return justfile_path, tmpdir
end

-- Cleanup test files
local function cleanup(tmpdir)
  vim.fn.delete(tmpdir, "rf")
end

-- Test: Plugin loads correctly
function M.test_plugin_loads()
  print("Test: Plugin loads correctly")
  local ok, just_runner = pcall(require, "just-runner")
  assert_true(ok, "Failed to load just-runner module")
  assert_not_nil(just_runner.setup, "setup function should exist")
  assert_not_nil(just_runner.run, "run function should exist")
  print("  ✓ Plugin loads successfully")
end

-- Test: Default configuration
function M.test_default_config()
  print("Test: Default configuration")
  local just_runner = require("just-runner")
  just_runner.setup()
  
  assert_eq(just_runner.config.picker, "snacks", "Default picker should be snacks")
  assert_eq(just_runner.config.window_position, "bottom", "Default position should be bottom")
  assert_eq(just_runner.config.close_on_success, true, "Should close on success by default")
  assert_eq(just_runner.config.close_on_error, false, "Should not close on error by default")
  assert_eq(just_runner.config.pause_before_close, 2000, "Default pause should be 2000ms")
  print("  ✓ Default configuration is correct")
end

-- Test: Custom configuration
function M.test_custom_config()
  print("Test: Custom configuration")
  local just_runner = require("just-runner")
  
  just_runner.setup({
    picker = "telescope",
    window_position = "float",
    close_on_success = false,
    pause_before_close = 1000,
  })
  
  assert_eq(just_runner.config.picker, "telescope", "Picker should be telescope")
  assert_eq(just_runner.config.window_position, "float", "Position should be float")
  assert_eq(just_runner.config.close_on_success, false, "Should not close on success")
  assert_eq(just_runner.config.pause_before_close, 1000, "Pause should be 1000ms")
  print("  ✓ Custom configuration works")
end

-- Test: Justfile parsing
function M.test_justfile_parsing()
  print("Test: Justfile parsing")
  local content = [[
# Comment
build:
    cargo build

test *args:
    cargo test {{args}}

deploy env:
    ./deploy.sh {{env}}

# Another comment
run:
    cargo run
]]
  
  local justfile_path, tmpdir = create_test_justfile(content)
  
  -- We need to test the internal parse function
  -- For now, we'll just verify the file was created
  local file = io.open(justfile_path, "r")
  assert_not_nil(file, "Test justfile should exist")
  file:close()
  
  cleanup(tmpdir)
  print("  ✓ Justfile parsing test setup works")
end

-- Test: Command registration
function M.test_commands_registered()
  print("Test: Commands are registered")
  
  local commands = vim.api.nvim_get_commands({})
  assert_not_nil(commands.JustRun, "JustRun command should be registered")
  assert_not_nil(commands.Just, "Just command should be registered")
  
  print("  ✓ Commands registered successfully")
end

-- Run all tests
function M.run_all()
  print("\n=== Running just-runner.nvim tests ===\n")
  
  local tests = {
    M.test_plugin_loads,
    M.test_default_config,
    M.test_custom_config,
    M.test_justfile_parsing,
    M.test_commands_registered,
  }
  
  local passed = 0
  local failed = 0
  
  for _, test in ipairs(tests) do
    local ok, err = pcall(test)
    if ok then
      passed = passed + 1
    else
      failed = failed + 1
      print("  ✗ Test failed: " .. tostring(err))
    end
  end
  
  print(string.format("\n=== Test Results: %d passed, %d failed ===\n", passed, failed))
  return failed == 0
end

-- Auto-run if executed directly
if vim.v.vim_did_enter == 1 then
  M.run_all()
end

return M
