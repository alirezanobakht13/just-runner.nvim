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

-- Safe wrapper function for completion
local function safe_complete_targets(arg_lead, cmd_line, cursor_pos)
  local ok, result = pcall(function()
    -- Try to get targets
    local jr_ok, jr = pcall(require, "just-runner")
    if not jr_ok then
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
  end)
  
  if ok then
    return result
  else
    return {}
  end
end

-- Safe wrapper for running just-runner
local function safe_run_just_runner(target_name)
  local ok, err = pcall(function()
    local jr = require("just-runner")
    
    -- Check if just command exists
    if vim.fn.executable("just") == 0 then
      vim.notify("just-runner.nvim: 'just' command not found. Please install it from https://github.com/casey/just", vim.log.levels.ERROR)
      return
    end
    
    if target_name and target_name ~= "" then
      jr.run_target_by_name(target_name)
    else
      jr.run()
    end
  end)
  
  if not ok then
    vim.notify("just-runner.nvim: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Create user command with completion
vim.api.nvim_create_user_command("JustRun", function(opts)
  safe_run_just_runner(opts.args)
end, {
  desc = "Run a justfile target",
  nargs = "?",
  complete = safe_complete_targets,
})

-- Optional: Create shorter alias
vim.api.nvim_create_user_command("Just", function(opts)
  safe_run_just_runner(opts.args)
end, {
  desc = "Run a justfile target (alias for JustRun)",
  nargs = "?",
  complete = safe_complete_targets,
})
