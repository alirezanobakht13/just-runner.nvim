-- Plugin entry point
if vim.fn.has("nvim-0.10.0") == 0 then
  vim.api.nvim_err_writeln("just-runner.nvim requires Neovim >= 0.10.0")
  return
end

-- Prevent loading the plugin twice
if vim.g.loaded_just_runner then
  return
end
vim.g.loaded_just_runner = 1

-- Completion function for justfile targets
local function complete_targets(arg_lead, cmd_line, cursor_pos)
  -- Safely try to get targets
  local ok, jr = pcall(require, "just-runner")
  if not ok then
    return {}
  end
  
  local targets = jr.get_targets()
  
  if not targets then
    return {}
  end
  
  -- Filter targets that match the input
  local matches = {}
  for _, target in ipairs(targets) do
    if target.name:find("^" .. vim.pesc(arg_lead)) then
      table.insert(matches, target.name)
    end
  end
  
  return matches
end

-- Create user command with completion
vim.api.nvim_create_user_command("JustRun", function(opts)
  local ok, jr = pcall(require, "just-runner")
  if not ok then
    vim.notify("just-runner.nvim: Failed to load plugin", vim.log.levels.ERROR)
    return
  end
  
  -- Check if just command exists
  if vim.fn.executable("just") == 0 then
    vim.notify("just-runner.nvim: 'just' command not found. Please install it from https://github.com/casey/just", vim.log.levels.ERROR)
    return
  end
  
  -- If a target name is provided, run it directly
  if opts.args and opts.args ~= "" then
    jr.run_target_by_name(opts.args)
  else
    -- Otherwise show the picker
    jr.run()
  end
end, {
  desc = "Run a justfile target",
  nargs = "?",
  complete = complete_targets,
})

-- Optional: Create shorter alias
vim.api.nvim_create_user_command("Just", function(opts)
  local ok, jr = pcall(require, "just-runner")
  if not ok then
    vim.notify("just-runner.nvim: Failed to load plugin", vim.log.levels.ERROR)
    return
  end
  
  -- Check if just command exists
  if vim.fn.executable("just") == 0 then
    vim.notify("just-runner.nvim: 'just' command not found. Please install it from https://github.com/casey/just", vim.log.levels.ERROR)
    return
  end
  
  -- If a target name is provided, run it directly
  if opts.args and opts.args ~= "" then
    jr.run_target_by_name(opts.args)
  else
    -- Otherwise show the picker
    jr.run()
  end
end, {
  desc = "Run a justfile target (alias for JustRun)",
  nargs = "?",
  complete = complete_targets,
})
