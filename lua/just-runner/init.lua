local M = {}

-- Default configuration
M.config = {
  picker = "snacks", -- "telescope" or "snacks"
  window_position = "bottom", -- "bottom", "right", "float"
  close_on_success = true,
  close_on_error = false,
  pause_before_close = 2000, -- milliseconds
  window_size = {
    width = 0.8,
    height = 0.4,
  },
  which_key = {
    enabled = true,
    keymap = "<leader>j",
    icon = "󰐊",
    desc = "Just Run",
  },
}

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Check if 'just' command is available
  if vim.fn.executable("just") == 0 then
    vim.notify(
      "just-runner.nvim: 'just' command not found. Please install it from https://github.com/casey/just",
      vim.log.levels.WARN
    )
  end
  
  -- Register with which-key if available and enabled
  if M.config.which_key.enabled then
    local has_wk, wk = pcall(require, "which-key")
    if has_wk and M.config.which_key.keymap then
      wk.add({
        { M.config.which_key.keymap, icon = M.config.which_key.icon, desc = M.config.which_key.desc },
      })
    end
  end
end

-- Find justfile in current directory or parent directories
local function find_justfile()
  local current_dir = vim.fn.getcwd()
  local justfile_names = { "justfile", "Justfile", ".justfile" }
  
  while current_dir ~= "/" and current_dir ~= "" do
    for _, name in ipairs(justfile_names) do
      local path = current_dir .. "/" .. name
      if vim.fn.filereadable(path) == 1 then
        return path, current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  
  return nil, nil
end

-- Parse justfile and extract targets
local function parse_justfile(justfile_path)
  local targets = {}
  local file = io.open(justfile_path, "r")
  
  if not file then
    return targets
  end
  
  for line in file:lines() do
    -- Skip empty lines and comments
    if line:match("^%s*$") or line:match("^%s*#") then
      goto continue
    end
    
    -- Match recipe definitions (lines starting with non-space and containing :)
    -- Pattern: name params: recipe
    local target, params = line:match("^([%w_-]+)%s*([^:]*):.*$")
    if target and not line:match("^%s*#") and not line:match("^set%s") then
      -- Clean up parameters
      params = params:gsub("^%s+", ""):gsub("%s+$", "")
      table.insert(targets, {
        name = target,
        params = params ~= "" and params or nil,
        display = params ~= "" and string.format("%s %s", target, params) or target,
      })
    end
    
    ::continue::
  end
  
  file:close()
  return targets
end

-- Get terminal buffer configuration
local function get_term_config()
  local config = M.config
  local buf = vim.api.nvim_create_buf(false, true)
  local win_opts = {}
  
  if config.window_position == "float" then
    local width = math.floor(vim.o.columns * config.window_size.width)
    local height = math.floor(vim.o.lines * config.window_size.height)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    
    win_opts = {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    }
  elseif config.window_position == "right" then
    local width = math.floor(vim.o.columns * config.window_size.width)
    win_opts = {
      split = "right",
      win = 0,
    }
    vim.api.nvim_open_win(buf, true, win_opts)
    vim.api.nvim_win_set_width(0, width)
    return buf
  else -- bottom (default)
    local height = math.floor(vim.o.lines * config.window_size.height)
    win_opts = {
      split = "below",
      win = 0,
    }
    vim.api.nvim_open_win(buf, true, win_opts)
    vim.api.nvim_win_set_height(0, height)
    return buf
  end
  
  vim.api.nvim_open_win(buf, true, win_opts)
  return buf
end

-- Run a justfile target
local function run_target(target, args, justfile_dir)
  -- Check if just command exists before running
  if vim.fn.executable("just") == 0 then
    vim.notify("just-runner.nvim: 'just' command not found. Please install it from https://github.com/casey/just", vim.log.levels.ERROR)
    return
  end
  
  local buf = get_term_config()
  local cmd = "just " .. target.name
  
  if args and args ~= "" then
    cmd = cmd .. " " .. args
  end
  
  -- Change to justfile directory and run command
  local full_cmd = string.format("cd %s && %s", justfile_dir, cmd)
  
  -- Start terminal job
  local job_id = vim.fn.termopen(full_cmd, {
    on_exit = function(_, exit_code, _)
      local should_close = (exit_code == 0 and M.config.close_on_success) or
                           (exit_code ~= 0 and M.config.close_on_error)
      
      if should_close then
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(buf) then
            local wins = vim.fn.win_findbuf(buf)
            for _, win in ipairs(wins) do
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end, M.config.pause_before_close)
      end
    end,
  })
  
  -- Enter insert mode in terminal
  vim.cmd("startinsert")
end

-- Prompt for arguments if target requires them
local function prompt_for_args(target, justfile_dir)
  if target.params then
    vim.ui.input({
      prompt = string.format("Arguments for '%s' (%s): ", target.name, target.params),
    }, function(input)
      if input then
        run_target(target, input, justfile_dir)
      end
    end)
  else
    run_target(target, nil, justfile_dir)
  end
end

-- Telescope picker
local function telescope_picker(targets, justfile_dir)
  local has_telescope, telescope = pcall(require, "telescope")
  if not has_telescope then
    vim.notify("Telescope not found. Please install telescope.nvim or use snacks picker.", vim.log.levels.ERROR)
    return
  end
  
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  
  pickers.new({}, {
    prompt_title = "Just Targets",
    finder = finders.new_table({
      results = targets,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        prompt_for_args(selection.value, justfile_dir)
      end)
      return true
    end,
  }):find()
end

-- Snacks picker (default)
local function snacks_picker(targets, justfile_dir)
  -- For now, let's use vim.ui.select as it's more reliable
  -- We can add proper snacks integration later once we figure out the exact API
  vim.ui.select(targets, {
    prompt = "Select Just Target:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if choice then
      prompt_for_args(choice, justfile_dir)
    end
  end)
end

-- Main run function
function M.run()
  local justfile_path, justfile_dir = find_justfile()
  
  if not justfile_path then
    vim.notify("No justfile found in current directory or parent directories", vim.log.levels.ERROR)
    return
  end
  
  local targets = parse_justfile(justfile_path)
  
  -- Debug: show what was parsed
  if vim.g.just_runner_debug then
    print("Found justfile: " .. justfile_path)
    print("Parsed " .. #targets .. " targets:")
    for _, t in ipairs(targets) do
      print("  - " .. t.display)
    end
  end
  
  if #targets == 0 then
    vim.notify("No targets found in justfile", vim.log.levels.WARN)
    return
  end
  
  -- Use configured picker
  if M.config.picker == "telescope" then
    telescope_picker(targets, justfile_dir)
  else
    snacks_picker(targets, justfile_dir)
  end
end

-- Get list of targets (for completion)
function M.get_targets()
  local justfile_path, justfile_dir = find_justfile()
  
  if not justfile_path then
    return nil
  end
  
  local targets = parse_justfile(justfile_path)
  return targets
end

-- Run a specific target by name
function M.run_target_by_name(target_name)
  local justfile_path, justfile_dir = find_justfile()
  
  if not justfile_path then
    vim.notify("No justfile found in current directory or parent directories", vim.log.levels.ERROR)
    return
  end
  
  local targets = parse_justfile(justfile_path)
  
  -- Find the target
  local found_target = nil
  for _, target in ipairs(targets) do
    if target.name == target_name then
      found_target = target
      break
    end
  end
  
  if not found_target then
    vim.notify("Target '" .. target_name .. "' not found in justfile", vim.log.levels.ERROR)
    return
  end
  
  -- Run the target
  prompt_for_args(found_target, justfile_dir)
end

return M
