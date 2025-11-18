local vim = vim

local M = {}

local defaults = {
  root = vim.fn.getcwd(),
  glob = "*.md",
  ignore_dirs = { ".git", ".obsidian", "node_modules" },
  commands = true,
  keymaps = {
    global_value = "<leader>grv",
    global_key = "<leader>grk",
    buffer_value = "<leader>brv",
    buffer_key = "<leader>brk",
    global_remove = "<leader>grl",
    buffer_remove = "<leader>brl",
  },
}

M.config = vim.deepcopy(defaults)
M._commands_registered = false
M._keymaps_registered = false

local function notify(msg, level)
  vim.notify("[MorphyML] " .. msg, level or vim.log.levels.INFO)
end

local function glob_to_pattern(glob)
  local escaped = glob:gsub("([%^%$%(%)%%%.%[%]%+%-%?])", "%%%1")
  escaped = escaped:gsub("%*", ".*")
  return "^" .. escaped .. "$"
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local lines = {}
  for line in f:lines() do
    lines[#lines + 1] = line
  end
  f:close()
  return lines
end

local function write_file(path, lines)
  local f = io.open(path, "w")
  if not f then
    notify("failed to write " .. path, vim.log.levels.ERROR)
    return false
  end
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  return true
end

local function should_ignore(path)
  for _, dir in ipairs(M.config.ignore_dirs or {}) do
    if path:find(dir, 1, true) then
      return true
    end
  end
  return false
end

local function list_markdown_files()
  local root = vim.fs.normalize(M.config.root or vim.fn.getcwd())
  local pattern = glob_to_pattern(M.config.glob or "*.md")
  local predicate = function(name, path)
    if should_ignore(path or "") then
      return false
    end
    return name:match(pattern) ~= nil
  end
  return vim.fs.find(predicate, { path = root, type = "file" })
end

local function yaml_bounds(lines)
  local start_idx, end_idx
  for idx, line in ipairs(lines) do
    if line:match("^%s*---%s*$") then
      if not start_idx then
        start_idx = idx
      else
        end_idx = idx
        break
      end
    end
  end
  return start_idx, end_idx
end

local function replace_yaml(lines, search_term, replacement, mode)
  local start_idx, end_idx = yaml_bounds(lines)
  if not (start_idx and end_idx and end_idx > start_idx) then
    return 0
  end
  local count = 0
  local pattern = vim.pesc(search_term)
  for i = start_idx + 1, end_idx - 1 do
    local line = lines[i]
    local key, value = line:match("^(%s*%S+:%s*)(.*)$")
    if key and value then
      if mode == "key" then
        local new_key, replaced = key:gsub(pattern, replacement)
        if replaced > 0 then
          lines[i] = new_key .. value
          count = count + replaced
        end
      elseif mode == "value" then
        local new_value, replaced = value:gsub(pattern, replacement)
        if replaced > 0 then
          lines[i] = key .. new_value
          count = count + replaced
        end
      end
    end
  end
  return count
end

local function remove_yaml_lines(lines, search_term)
  local start_idx, end_idx = yaml_bounds(lines)
  if not (start_idx and end_idx and end_idx > start_idx) then
    return 0
  end
  local new_lines = {}
  local removed = 0
  for idx, line in ipairs(lines) do
    if idx <= start_idx or idx >= end_idx then
      table.insert(new_lines, line)
    else
      if line:find(search_term, 1, true) then
        removed = removed + 1
      else
        table.insert(new_lines, line)
      end
    end
  end
  if removed > 0 then
    for i = 1, #new_lines do
      lines[i] = new_lines[i]
    end
    for i = #new_lines + 1, #lines do
      lines[i] = nil
    end
  end
  return removed
end

local function prompt(text)
  local value = vim.fn.input(text)
  if value == "" then
    notify("operation cancelled", vim.log.levels.WARN)
    return nil
  end
  return value
end

local function for_each_yaml_file(callback)
  local files = list_markdown_files()
  if #files == 0 then
    notify("no markdown files found", vim.log.levels.INFO)
    return 0
  end
  local updated = 0
  for _, file in ipairs(files) do
    local lines = read_file(file)
    if lines then
      local changes = callback(lines, file)
      if changes > 0 then
        if write_file(file, lines) then
          updated = updated + 1
          notify(string.format("%s: %d change(s)", vim.fn.fnamemodify(file, ":t"), changes))
        end
      end
    end
  end
  notify(string.format("processed %d file(s)", updated))
  return updated
end

local function replace_global(mode)
  local term = prompt("Replace term: ")
  if not term then
    return
  end
  local replacement = prompt("Replacement: ")
  if not replacement then
    return
  end
  for_each_yaml_file(function(lines)
    return replace_yaml(lines, term, replacement, mode)
  end)
end

local function replace_buffer(mode)
  local term = prompt("Replace term: ")
  if not term then
    return
  end
  local replacement = prompt("Replacement: ")
  if not replacement then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local count = replace_yaml(lines, term, replacement, mode)
  if count > 0 then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    notify(string.format("%s: %d change(s)", vim.fn.bufname(bufnr), count))
  else
    notify("no matches in current buffer", vim.log.levels.INFO)
  end
end

local function remove_global()
  local term = prompt("Term to remove: ")
  if not term then
    return
  end
  for_each_yaml_file(function(lines)
    return remove_yaml_lines(lines, term)
  end)
end

local function remove_buffer()
  local term = prompt("Term to remove: ")
  if not term then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local count = remove_yaml_lines(lines, term)
  if count > 0 then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    notify("removed " .. count .. " line(s)")
  else
    notify("no matches in current buffer", vim.log.levels.INFO)
  end
end

M.replace_global_value = function()
  replace_global("value")
end

M.replace_global_key = function()
  replace_global("key")
end

M.replace_buffer_value = function()
  replace_buffer("value")
end

M.replace_buffer_key = function()
  replace_buffer("key")
end

M.remove_global = remove_global
M.remove_buffer = remove_buffer

local function register_commands()
  if M._commands_registered or not M.config.commands then
    return
  end
  vim.api.nvim_create_user_command("MorphyReplaceGlobal", function(opts)
    local mode = opts.args == "key" and "key" or "value"
    replace_global(mode)
  end, { nargs = "?", complete = function()
    return { "key", "value" }
  end })
  vim.api.nvim_create_user_command("MorphyReplaceBuffer", function(opts)
    local mode = opts.args == "key" and "key" or "value"
    replace_buffer(mode)
  end, { nargs = "?", complete = function()
    return { "key", "value" }
  end })
  vim.api.nvim_create_user_command("MorphyRemoveGlobal", remove_global, {})
  vim.api.nvim_create_user_command("MorphyRemoveBuffer", remove_buffer, {})
  M._commands_registered = true
end

local function register_keymaps()
  if M._keymaps_registered or not M.config.keymaps then
    return
  end
  local maps = M.config.keymaps
  if maps.global_value then
    vim.keymap.set("n", maps.global_value, M.replace_global_value, { desc = "Morphy: global value replace" })
  end
  if maps.global_key then
    vim.keymap.set("n", maps.global_key, M.replace_global_key, { desc = "Morphy: global key replace" })
  end
  if maps.buffer_value then
    vim.keymap.set("n", maps.buffer_value, M.replace_buffer_value, { desc = "Morphy: buffer value replace" })
  end
  if maps.buffer_key then
    vim.keymap.set("n", maps.buffer_key, M.replace_buffer_key, { desc = "Morphy: buffer key replace" })
  end
  if maps.global_remove then
    vim.keymap.set("n", maps.global_remove, M.remove_global, { desc = "Morphy: global remove line" })
  end
  if maps.buffer_remove then
    vim.keymap.set("n", maps.buffer_remove, M.remove_buffer, { desc = "Morphy: buffer remove line" })
  end
  M._keymaps_registered = true
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
  register_commands()
  register_keymaps()
end

return M
