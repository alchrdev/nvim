-- Dynamic YAML frontmatter manipulation:
-- • Replace keys or values (globally or in the current buffer)
-- • Remove YAML lines containing specified terms

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

-- Function to detect if we are on Windows
local function is_windows()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

-- Function to find the path to ripgrep (rg) on the system
local function find_rg()
  local cmd = is_windows() and "where rg" or "command -v rg"
  local handle = io.popen(cmd)
  if not handle then return "" end
  local output = handle:read("*a") or ""
  handle:close()
  return output:gsub("%s+", "")
end

-- Function to read a file and return its lines as a table
local function read_file_lines(filepath)
  local f = io.open(filepath, "r")
  if not f then return nil end
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

-- Function to write lines back to a file
local function write_file_lines(filepath, lines)
  local f = io.open(filepath, "w")
  if not f then
    vim.notify("Error writing: " .. filepath, vim.log.levels.ERROR)
    return false
  end
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  return true
end

--------------------------------------------------------------------------------
-- Dynamic YAML Replacement Function
-- Replaces text in either the key or the value, based on mode ("key" or "value")
--------------------------------------------------------------------------------
local function replace_yaml_dynamic(lines, search_term, replacement, mode)
  local in_yaml = false
  local total_replacements = 0
  -- Escape the term for literal matching
  local search_pattern = vim.pesc(search_term)
  for _, line in ipairs(lines) do
    if line:match("^%s*---%s*$") then
      in_yaml = not in_yaml
    elseif in_yaml then
      local prefix, value = line:match("^(%s*%S+:%s*)(.*)$")
      if prefix and value then
        if mode == "key" then
          local new_prefix, count = prefix:gsub(search_pattern, replacement)
          if count > 0 then
            line = new_prefix .. value
            total_replacements = total_replacements + count
          end
        elseif mode == "value" then
          local new_value, count = value:gsub(search_pattern, replacement)
          if count > 0 then
            line = prefix .. new_value
            total_replacements = total_replacements + count
          end
        else
          vim.notify("Unsupported mode", vim.log.levels.ERROR)
          return total_replacements
        end
        -- Update the line in the table
        lines[_] = line
      end
    end
  end
  return total_replacements
end

--------------------------------------------------------------------------------
-- Global Replace Dynamic Function
-- Replaces in files with YAML frontmatter based on mode ("key" or "value")
--------------------------------------------------------------------------------
local function global_replace_dynamic(mode)
  if mode ~= "key" and mode ~= "value" then
    vim.notify("Unsupported mode", vim.log.levels.ERROR)
    return
  end

  local search_term = vim.fn.input("Term to replace: ")
  if search_term == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local replacement = vim.fn.input("Replacement: ")
  if replacement == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local rg_path = find_rg()
  if rg_path == "" then
    vim.notify("rg not found in PATH", vim.log.levels.ERROR)
    return
  end

  -- Pattern to allow whitespace around '---'
  local rg_cmd = 'rg -l "^\\s*---\\s*$" --glob "*.md" --no-ignore'
  local file_handle = io.popen(rg_cmd)
  if not file_handle then
    vim.notify("Search error", vim.log.levels.ERROR)
    return
  end

  local files = {}
  for file in file_handle:lines() do
    table.insert(files, file)
  end
  file_handle:close()

  if #files == 0 then
    vim.notify("No files with YAML frontmatter found", vim.log.levels.INFO)
    return
  end

  local updated_files = 0
  for _, file in ipairs(files) do
    local lines = read_file_lines(file)
    if lines then
      local replacements = replace_yaml_dynamic(lines, search_term, replacement, mode)
      if replacements > 0 then
        if write_file_lines(file, lines) then
          vim.notify(string.format("Updated: %s (%d replacement(s))", file, replacements), vim.log.levels.INFO)
          updated_files = updated_files + 1
        end
      end
    else
      vim.notify("Error reading: " .. file, vim.log.levels.ERROR)
    end
  end

  if updated_files == 0 then
    vim.notify("No changes made to the YAML in the files", vim.log.levels.INFO)
  else
    vim.notify("Global update completed successfully in " .. updated_files .. " file(s)", vim.log.levels.INFO)
  end

  vim.cmd('bufdo e')
end

--------------------------------------------------------------------------------
-- Buffer Replace Dynamic Function
-- Replaces in the current file's YAML based on mode ("key" or "value")
--------------------------------------------------------------------------------
local function buffer_replace_dynamic(mode)
  if mode ~= "key" and mode ~= "value" then
    vim.notify("Unsupported mode", vim.log.levels.ERROR)
    return
  end

  local search_term = vim.fn.input("Term to replace: ")
  if search_term == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local replacement = vim.fn.input("Replacement: ")
  if replacement == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t')

  local lines = read_file_lines(file_path)
  if not lines then
    vim.notify("Error in " .. file_name, vim.log.levels.ERROR)
    return
  end

  local replacements = replace_yaml_dynamic(lines, search_term, replacement, mode)
  if replacements > 0 then
    if write_file_lines(file_path, lines) then
      vim.notify(string.format("%s: '%s' → '%s' (%d)", file_name, search_term, replacement, replacements), vim.log.levels.INFO)
    end
  else
    vim.notify(file_name .. ": No matches", vim.log.levels.INFO)
  end

  vim.cmd('edit!')
end

--------------------------------------------------------------------------------
-- YAML Line Removal Function
-- Removes entire lines in the YAML frontmatter if they contain the specified term
--------------------------------------------------------------------------------
local function remove_yaml_line(lines, search_term)
  local in_yaml = false
  local removals = 0
  local new_lines = {}
  for _, line in ipairs(lines) do
    if line:match("^%s*---%s*$") then
      in_yaml = not in_yaml
      table.insert(new_lines, line)
    elseif in_yaml then
      if string.find(line, search_term, 1, true) then
        removals = removals + 1
      else
        table.insert(new_lines, line)
      end
    else
      table.insert(new_lines, line)
    end
  end
  for i = 1, #lines do lines[i] = nil end
  for i, l in ipairs(new_lines) do
    lines[i] = l
  end
  return removals
end

--------------------------------------------------------------------------------
-- Global Remove Function
-- Removes entire YAML property lines (key and value) that contain the specified term
--------------------------------------------------------------------------------
local function global_remove_line()
  local search_term = vim.fn.input("Term to remove: ")
  if search_term == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local rg_path = find_rg()
  if rg_path == "" then
    vim.notify("rg not found in PATH", vim.log.levels.ERROR)
    return
  end

  local rg_cmd = 'rg -l "^\\s*---\\s*$" --glob "*.md" --no-ignore'
  local file_handle = io.popen(rg_cmd)
  if not file_handle then
    vim.notify("Search error", vim.log.levels.ERROR)
    return
  end

  local files = {}
  for file in file_handle:lines() do
    table.insert(files, file)
  end
  file_handle:close()

  if #files == 0 then
    vim.notify("No files with YAML frontmatter found", vim.log.levels.INFO)
    return
  end

  local updated_files = 0
  for _, file in ipairs(files) do
    local lines = read_file_lines(file)
    if lines then
      local removals = remove_yaml_line(lines, search_term)
      if removals > 0 then
        if write_file_lines(file, lines) then
          vim.notify(string.format("Updated: %s (%d removal(s))", file, removals), vim.log.levels.INFO)
          updated_files = updated_files + 1
        end
      end
    else
      vim.notify("Error reading: " .. file, vim.log.levels.ERROR)
    end
  end

  if updated_files == 0 then
    vim.notify("No removals made in the YAML", vim.log.levels.INFO)
  else
    vim.notify("Global removal completed in " .. updated_files .. " file(s)", vim.log.levels.INFO)
  end

  vim.cmd('bufdo e')
end

--------------------------------------------------------------------------------
-- Buffer Remove Function
-- Removes entire YAML property lines in the current file that contain the specified term
--------------------------------------------------------------------------------
local function buffer_remove_line()
  local search_term = vim.fn.input("Term to remove: ")
  if search_term == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t')
  local lines = read_file_lines(file_path)
  if not lines then
    vim.notify("Error in " .. file_name, vim.log.levels.ERROR)
    return
  end

  local removals = remove_yaml_line(lines, search_term)
  if removals > 0 then
    if write_file_lines(file_path, lines) then
      vim.notify(string.format("%s: '%s' removed (%d)", file_name, search_term, removals), vim.log.levels.INFO)
    end
  else
    vim.notify(file_name .. ": No matches", vim.log.levels.INFO)
  end

  vim.cmd('edit!')
end

--------------------------------------------------------------------------------
-- Command and Keymap Registration
--------------------------------------------------------------------------------

vim.api.nvim_create_user_command('GlobalReplaceDynamic', function(opts)
  local mode = opts.args or "value"
  global_replace_dynamic(mode)
end, { nargs = "?" })

vim.api.nvim_create_user_command('BufferReplaceDynamic', function(opts)
  local mode = opts.args or "value"
  buffer_replace_dynamic(mode)
end, { nargs = "?" })

vim.api.nvim_create_user_command('GlobalRemoveLine', function()
  global_remove_line()
end, {})

vim.api.nvim_create_user_command('BufferRemoveLine', function()
  buffer_remove_line()
end, {})

-- Keymaps for Replace functions
vim.keymap.set('n', '<leader>gv', function() global_replace_dynamic("value") end, { desc = "Global Value Replace" })
vim.keymap.set('n', '<leader>gk', function() global_replace_dynamic("key") end, { desc = "Global Key Replace" })
vim.keymap.set('n', '<leader>bv', function() buffer_replace_dynamic("value") end, { desc = "Buffer Value Replace" })
vim.keymap.set('n', '<leader>bk', function() buffer_replace_dynamic("key") end, { desc = "Buffer Key Replace" })

-- Keymaps for Remove functions (removing entire YAML lines)
vim.keymap.set('n', '<leader>gr', function() global_remove_line() end, { desc = "Global Remove" })
vim.keymap.set('n', '<leader>br', function() buffer_remove_line() end, { desc = "Buffer Remove" })
