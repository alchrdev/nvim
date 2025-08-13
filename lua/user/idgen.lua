-- Generate new ID and update YAML header with it

local function generate_new_id()
  -- You can also use os.date("%Y%d%H%M") if preferred.
  return os.date("%Y%d%H%M")
end

local function update_yaml_header()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local new_id = generate_new_id()
  local yaml_start, yaml_end = nil, nil

  -- Detect YAML block boundaries
  for i, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      if not yaml_start then
        yaml_start = i
      else
        yaml_end = i
        break
      end
    end
  end

  if yaml_start and yaml_end then
    -- Update the 'id' field if it exists
    local id_updated = false
    for i = yaml_start, yaml_end do
      if lines[i]:match("^id:") then
        lines[i] = "id: " .. new_id
        id_updated = true
        break
      end
    end
    if not id_updated then
      table.insert(lines, yaml_start + 1, "id: " .. new_id)
    end
  else
    -- Create a new YAML block if missing
    table.insert(lines, 1, "---")
    table.insert(lines, 2, "id: " .. new_id)
    table.insert(lines, 3, "---")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.notify("Header updated; new ID: " .. new_id, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>uy', update_yaml_header, { desc = "[U]pdate YAML header with new ID" })
