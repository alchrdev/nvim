-- Rename files and automatically update Markdown links.
-- Unify file renaming with link format normalization.

local function get_name_from_file(file_path)
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
  local resolved_path = file_path
  if not file_path:match("^/") then
    resolved_path = current_dir .. "/" .. file_path
  end
  resolved_path = vim.fn.fnamemodify(resolved_path, ":p")
  local f = io.open(resolved_path, "r")
  if not f then
    return nil
  end
  local title = nil
  for _ = 1, 10 do
    local line = f:read("*line")
    if not line then break end
    if line:match("^title:") then
      title = line:match("title:%s*['\"](.-)['\"]")
      break
    end
  end
  f:close()
  return title
end

local function standardize_links()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local pattern = "(%[[^%]]-%])%(([^%s%)]+)%)"
  local links_updated = false
  local link_resolved = false

  for i, line in ipairs(lines) do
    if not line:match("^!%[") then
      local new_line = line:gsub(pattern, function(text, path)
        if path:match("^/") then
          return string.format("%s(%s)", text, path)
        elseif path:match("^%.%.?/") then
          local title = get_name_from_file(path)
          if title then
            link_resolved = true
            return string.format("[%s](%s)", title, path)
          end
          return string.format("%s(%s)", text, path)
        elseif not path:match("^%.?/") then
          local normalized_path = "./" .. path
          local title = get_name_from_file(normalized_path)
          if title then
            link_resolved = true
            return string.format("[%s](%s)", title, normalized_path)
          else
            return string.format("%s(%s)", text, normalized_path)
          end
        else
          return string.format("%s(%s)", text, path)
        end
      end)
      if new_line ~= line then
        links_updated = true
        lines[i] = new_line
      end
    end
  end

  if links_updated then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local msg = link_resolved and "Links standardized (YAML titles used)" or "Links standardized (./ prefix applied)"
    vim.notify(msg, vim.log.levels.INFO)
  end

  return links_updated
end

-- New version: update_references_in_file conserves the folder structure.
local function update_references_in_file(file_path, old_name, new_name)
  local file = io.open(file_path, "r")
  if not file then return false end
  local content = file:read("*all")
  file:close()

  -- Escapar el old_name para búsqueda literal
  local escaped_old_name = old_name:gsub("[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
  local modified = false

  -- Reemplaza en cada enlace (lo que esté entre paréntesis)
  local new_content = content:gsub("%(([^%)]+)%)", function(link)
    -- Si el enlace termina con el old_name, lo reemplazamos
    if link:match(escaped_old_name .. "$") then
      modified = true
      -- Reemplaza sólo la parte final (el nombre de archivo), conservando la ruta
      local new_link = link:gsub(escaped_old_name .. "$", new_name)
      return "(" .. new_link .. ")"
    else
      return "(" .. link .. ")"
    end
  end)

  if modified then
    local write_file = io.open(file_path, "w")
    if write_file then
      write_file:write(new_content)
      write_file:close()
      return true
    end
  end
  return false
end

local function rename_and_update_links()
  local current_file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(current_file, ":p:h")
  local old_name = vim.fn.fnamemodify(current_file, ":t")
  local project_root = vim.fn.getcwd()
  local new_name = vim.fn.input("New file name: ", old_name)
  if new_name == "" then
    vim.notify("Renaming canceled: name empty.", vim.log.levels.WARN)
    return
  end

  -- Siempre usar "/" como separador
  local new_path = dir .. "/" .. new_name
  new_path = vim.fn.fnamemodify(new_path, ":p")

  if vim.fn.filereadable(new_path) == 1 then
    local confirm = vim.fn.input("File exists. Overwrite? (y/N): ")
    if confirm:lower() ~= "y" then
      vim.notify("Renaming canceled.", vim.log.levels.INFO)
      return
    else
      os.remove(new_path)
    end
  end

  if vim.bo.modified then
    vim.cmd('write')
  end

  local function find_markdown_files(directory)
    local files = {}
    local handle
    if vim.fn.has('win32') == 1 then
      handle = io.popen(string.format('dir /b /s /a:-d "%s\\*.md"', directory))
    else
      handle = io.popen(string.format("find %q -type f -name '*.md'", directory))
    end
    if handle then
      for file in handle:lines() do
        table.insert(files, file)
      end
      handle:close()
    end
    return files
  end

  local success, err = os.rename(current_file, new_path)
  if not success then
    vim.notify(string.format("Error renaming file: %s", err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_name(0, new_path)
  vim.notify(string.format("Renamed to %s", new_name), vim.log.levels.INFO)

  local markdown_files = find_markdown_files(project_root)
  local updated_count = 0
  for _, file in ipairs(markdown_files) do
    if update_references_in_file(file, old_name, new_name) then
      updated_count = updated_count + 1
    end
  end

  if updated_count > 0 then
    vim.notify(string.format("Updated references in %d file(s)", updated_count), vim.log.levels.INFO)
  else
    vim.notify("No references updated", vim.log.levels.INFO)
  end

  vim.cmd("edit")
  standardize_links()
  vim.cmd("write")
end

vim.api.nvim_create_user_command('RenameFile', rename_and_update_links, {})
vim.keymap.set('n', '<leader>ru', rename_and_update_links, { desc = "[R]ename file and update links" })
vim.keymap.set('n', '<leader>sl', standardize_links, { desc = "[S]tandardize links" })
