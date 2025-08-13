-- Escape and unescape JSON-compatible multiline strings
local function escape_json_lines()
  -- Get selected range or current line
  local start_line, start_col, end_line, end_col
  -- Check if there's visual selection
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    -- Visual mode - use selection
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>") - 1
    start_col = vim.fn.col("'<") - 1
    end_col = vim.fn.col("'>")
  else
    -- No selection - use entire current line
    start_line = vim.fn.line('.') - 1
    end_line = start_line
    start_col = 0
    end_col = -1
  end
  -- Get lines from buffer
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
  if #lines == 0 then
    return
  end
  -- Process lines
  if #lines == 1 then
    -- Single line - process selection or complete line
    local line = lines[1]
    if end_col == -1 then
      end_col = #line
    end
    local before = line:sub(1, start_col)
    local selected = line:sub(start_col + 1, end_col)
    local after = line:sub(end_col + 1)
    -- Escape newlines (although there shouldn't be any in a single line)
    selected = selected:gsub('\n', '\\n')
    local new_line = before .. selected .. after
    vim.api.nvim_buf_set_lines(0, start_line, start_line + 1, false, {new_line})
  else
    -- Multiple lines
    local result = {}
    for i, line in ipairs(lines) do
      if i == 1 then
        -- First line - from start_col to end
        table.insert(result, line:sub(start_col + 1))
      elseif i == #lines then
        -- Last line - from beginning to end_col
        if end_col == -1 then
          table.insert(result, line)
        else
          table.insert(result, line:sub(1, end_col))
        end
      else
        -- Middle lines - complete
        table.insert(result, line)
      end
    end
    -- Join all lines with \n
    local escaped_text = table.concat(result, '\\n')
    -- Get context from first and last line
    local first_line = lines[1]
    local last_line = lines[#lines]
    local before = first_line:sub(1, start_col)
    local after = ""
    if end_col ~= -1 and #lines > 1 then
      after = last_line:sub(end_col + 1)
    elseif #lines == 1 and end_col ~= -1 then
      after = first_line:sub(end_col + 1)
    end
    -- Create new line
    local new_line = before .. escaped_text .. after
    -- Replace all selected lines with single line
    vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, {new_line})
  end
  vim.notify("JSON lines escaped successfully!")
end

-- Function to unescape newlines (inverse function)
local function unescape_json_lines()
  local start_line, start_col, end_line, end_col
  -- Check if there's visual selection
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>") - 1
    start_col = vim.fn.col("'<") - 1
    end_col = vim.fn.col("'>")
  else
    start_line = vim.fn.line('.') - 1
    end_line = start_line
    start_col = 0
    end_col = -1
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
  if #lines == 0 then
    return
  end
  -- For simplicity, process only first line if there are multiple
  local line = lines[1]
  if end_col == -1 then
    end_col = #line
  end
  local before = line:sub(1, start_col)
  local selected = line:sub(start_col + 1, end_col)
  local after = line:sub(end_col + 1)
  -- Unescape \n to real newlines
  local unescaped_lines = {}
  for part in selected:gmatch("([^\\n]*)\\n?") do
    if part ~= "" then
      table.insert(unescaped_lines, part)
    end
  end
  -- If no \n found, keep original text
  if #unescaped_lines <= 1 then
    unescaped_lines = {selected}
  end
  -- Add before to first element and after to last
  if #unescaped_lines > 0 then
    unescaped_lines[1] = before .. unescaped_lines[1]
    unescaped_lines[#unescaped_lines] = unescaped_lines[#unescaped_lines] .. after
  end
  -- Replace line with unescaped lines
  vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, unescaped_lines)
  vim.notify("JSON lines unescaped successfully!")
end

-- Create user commands
vim.api.nvim_create_user_command('JsonEscape', escape_json_lines, {
  desc = 'Escape newlines in selected text for JSON format',
  range = true
})

vim.api.nvim_create_user_command('JsonUnescape', unescape_json_lines, {
  desc = 'Unescape JSON newlines to real newlines',
  range = true
})

-- Suggested keymaps
-- Escape: <leader>je (JSON Escape)
vim.keymap.set({'n', 'v'}, '<leader>je', escape_json_lines, {
  desc = 'Escape newlines for JSON'
})

-- Unescape: <leader>ju (JSON Unescape)  
vim.keymap.set({'n', 'v'}, '<leader>ju', unescape_json_lines, {
  desc = 'Unescape JSON newlines'
})

-- Alternative more specific mapping
vim.keymap.set({'n', 'v'}, '<leader>jl', escape_json_lines, {
  desc = 'JSON Lines escape'
})

-- vim.notify("JSON escape functions loaded! Use <leader>je to escape, <leader>ju to unescape")
