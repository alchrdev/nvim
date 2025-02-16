-- Increment chapter and update last read date in YAML block

local function get_current_date()
  return os.date("%Y-%m-%d")
end

local function update_chapter_and_date()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local current_date = get_current_date()
  local yaml_start, yaml_end = nil, nil
  local updated_field = nil

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
    local chapter_updated = false
    local last_read_index = nil
    local last_watch_index = nil
    local last_view_index = nil

    for i = yaml_start + 1, yaml_end - 1 do
      if lines[i]:match("^chapter:") then
        local chapter = tonumber(lines[i]:match("chapter:%s*(%d+)")) or 0
        lines[i] = "chapter: " .. (chapter + 1)
        chapter_updated = true
      elseif lines[i]:match("^last_read:") then
        last_read_index = i
      elseif lines[i]:match("^last_watch:") then
        last_watch_index = i
      elseif lines[i]:match("^last_view:") then
        last_view_index = i
      end
    end

    if not chapter_updated then
      table.insert(lines, yaml_start + 1, "chapter: 1")
    end

    if last_read_index then
      lines[last_read_index] = "last_read: " .. current_date
      updated_field = "last_read"
    elseif last_watch_index then
      lines[last_watch_index] = "last_watch: " .. current_date
      updated_field = "last_watch"
    elseif last_view_index then
      lines[last_view_index] = "last_read: " .. current_date
      updated_field = "last_read (renamed from last_view)"
    else
      table.insert(lines, yaml_start + 1, "last_read: " .. current_date)
      updated_field = "last_read"
    end
  else
    local new_yaml = {
      "---",
      "chapter: 1",
      "last_read: " .. current_date,
      "---"
    }
    for i = #new_yaml, 1, -1 do
      table.insert(lines, 1, new_yaml[i])
    end
    updated_field = "last_read"
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.notify("Chapter updated! " .. updated_field .. " field updated.")
end

vim.keymap.set('n', '<leader>un', update_chapter_and_date, { desc = '[U]pdate [N]ew chapter and date' })
