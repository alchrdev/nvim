--------------------------------------------------------------------------------
-- YAML Empty Value Converter
-- Converts empty YAML values to a specific format ([], {}, etc.)
-- Provides both global and buffer-specific operations for safety
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
-- Properly handles line endings
local function read_file_lines(filepath)
  local f = io.open(filepath, "rb")  -- Use binary mode for consistent handling
  if not f then return nil end
  local content = f:read("*all")
  f:close()
  -- Normalize all line endings to LF
  content = content:gsub("\r\n", "\n"):gsub("\r", "\n")
  local lines = {}
  for line in content:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  -- If the last line didn't end with a newline, we need to handle it
  if content:sub(-1) ~= "\n" and #lines > 0 then
    lines[#lines] = content:match("([^\n]*)$")
  end
  return lines, content:sub(-1) == "\n"  -- Return lines and whether file ended with newline
end
-- Function to write lines back to a file (with consistent Unix line endings)
local function write_file_lines(filepath, lines, had_trailing_newline)
  local f = io.open(filepath, "wb")  -- Use binary mode for consistent output
  if not f then
    vim.notify("Error writing: " .. filepath, vim.log.levels.ERROR)
    return false
  end
  for i, line in ipairs(lines) do
    f:write(line)
    -- Add newline after each line except possibly the last one
    if i < #lines or had_trailing_newline then
      f:write("\n")  -- Always use Unix line endings (\n)
    end
  end
  f:close()
  return true
end
-- Function to escape special characters in regex patterns
local function escape_pattern(text)
  return text:gsub("([%(%)%.%%%+%-%*%?%[%^%$%]])", "%%%1")
end
-- Function to convert empty YAML values in a given set of lines
local function convert_empty_yaml_value(lines, key, replacement)
  local in_yaml = false
  local updated_lines = 0
  for i, line in ipairs(lines) do
    -- Detect start/end of YAML frontmatter
    if line:match("^%s*---%s*$") then
      in_yaml = not in_yaml
    elseif in_yaml then
      local escaped_key = escape_pattern(key)
      -- Modificamos el patrón para capturar el espacio después de los dos puntos
      local pattern = "^(%s*" .. escaped_key .. ":%s?)$"
      local prefix = line:match(pattern)
      if prefix then
        -- Asegurarnos de que haya un espacio entre los dos puntos y el reemplazo
        if prefix:sub(-1) == ":" then
          lines[i] = prefix .. " " .. replacement
        else
          lines[i] = prefix .. replacement
        end
        updated_lines = updated_lines + 1
      end
    end
  end
  return updated_lines
end
-- Buffer-specific function to convert empty YAML values
local function buffer_convert_empty_yaml()
  local key = vim.fn.input("Enter YAML key to search (without ':'): ")
  if not key or key == "" then
    vim.notify("Operation cancelled", vim.log.levels.WARN)
    return
  end
  local replacement = vim.fn.input("Enter replacement value (examples: '[]', '{}', 'null', 'pending', etc): ")
  if not replacement or replacement == "" then
    vim.notify("Operation cancelled", vim.log.levels.WARN)
    return
  end
  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t')
  local lines, had_trailing_newline = read_file_lines(file_path)
  if not lines then
    vim.notify("Error reading current buffer: " .. file_name, vim.log.levels.ERROR)
    return
  end
  local updated_lines = convert_empty_yaml_value(lines, key, replacement)
  if updated_lines > 0 then
    if write_file_lines(file_path, lines, had_trailing_newline) then
      vim.notify(string.format("Updated %s: %d line(s) changed", file_name, updated_lines), vim.log.levels.INFO)
      -- Save current cursor position
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      -- Set the fileformat before reloading
      vim.bo.fileformat = "unix"
      -- Reload buffer without triggering autocommands
      vim.cmd('edit! ' .. vim.fn.fnameescape(file_path))
      -- Restore cursor position
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  else
    vim.notify("No empty values found for key: " .. key, vim.log.levels.INFO)
  end
end
-- Global function to convert empty YAML values across files
local function global_convert_empty_yaml()
  local key = vim.fn.input("Enter YAML key to search (without ':'): ")
  if not key or key == "" then
    vim.notify("Operation cancelled", vim.log.levels.WARN)
    return
  end
  local replacement = vim.fn.input("Enter replacement value (example: '[]', '{}', etc): ")
  if not replacement or replacement == "" then
    vim.notify("Operation cancelled", vim.log.levels.WARN)
    return
  end
  local rg_path = find_rg()
  if rg_path == "" then
    vim.notify("ripgrep (rg) not found in PATH", vim.log.levels.ERROR)
    return
  end
  -- Escape the key properly for ripgrep (ahora busca también los casos con o sin espacio después de los dos puntos)
  local escaped_key = vim.fn.shellescape(key .. ":\\s*$")
  local rg_cmd = string.format('rg -l %s --glob "*.md" --no-ignore', escaped_key)
  vim.notify("Searching for files with empty '" .. key .. ":'...", vim.log.levels.INFO)
  local file_handle = io.popen(rg_cmd)
  if not file_handle then
    vim.notify("Error executing ripgrep", vim.log.levels.ERROR)
    return
  end
  local files = {}
  for file in file_handle:lines() do
    table.insert(files, file)
  end
  file_handle:close()
  vim.notify("Files found: " .. #files, vim.log.levels.INFO)
  if #files == 0 then
    vim.notify("No matching files found", vim.log.levels.INFO)
    return
  end
  local confirm = vim.fn.input("Proceed with global conversion? (y/n): ")
  if confirm:lower() ~= "y" and confirm:lower() ~= "yes" then
    vim.notify("Operation cancelled", vim.log.levels.WARN)
    return
  end
  local updated_files = 0
  local total_updated_lines = 0
  -- Keep track of modified open buffers
  local modified_buffers = {}
  for _, file in ipairs(files) do
    local lines, had_trailing_newline = read_file_lines(file)
    if lines then
      local updated_lines = convert_empty_yaml_value(lines, key, replacement)
      if updated_lines > 0 then
        if write_file_lines(file, lines, had_trailing_newline) then
          vim.notify(string.format("Updated %s: %d line(s)", file, updated_lines), vim.log.levels.INFO)
          updated_files = updated_files + 1
          total_updated_lines = total_updated_lines + updated_lines
          -- Check if the file is open in a buffer
          local bufnr = vim.fn.bufnr(file)
          if bufnr ~= -1 then
            table.insert(modified_buffers, bufnr)
          end
        end
      end
    else
      vim.notify("Error reading: " .. file, vim.log.levels.ERROR)
    end
  end
  -- Reload modified buffers individually with correct fileformat
  for _, bufnr in ipairs(modified_buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.bo[bufnr].fileformat = "unix"
        vim.cmd('edit!')
      end)
    end
  end
  vim.notify("\nSummary:", vim.log.levels.INFO)
  vim.notify("- Files processed: " .. #files, vim.log.levels.INFO)
  vim.notify("- Files updated: " .. updated_files, vim.log.levels.INFO)
  vim.notify("- Total lines modified: " .. total_updated_lines, vim.log.levels.INFO)
end
-- Register commands
vim.api.nvim_create_user_command('BufferConvertEmptyYAML', function()
  buffer_convert_empty_yaml()
end, {})
vim.api.nvim_create_user_command('GlobalConvertEmptyYAML', function()
  global_convert_empty_yaml()
end, {})
-- Add keymaps
vim.keymap.set('n', '<leader>yeb', function() buffer_convert_empty_yaml() end, { desc = "Convert empty YAML values in buffer" })
vim.keymap.set('n', '<leader>yeg', function() global_convert_empty_yaml() end, { desc = "Convert empty YAML values globally" })
