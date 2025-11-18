local vim = vim

local M = {}

local defaults = {
  max_marks = 10,
  persist_marks = true,
  data_dir = vim.fn.stdpath("data") .. "/niply",
  menu = {
    width = 60,
    height = 15,
    border = "rounded",
    title = " Niply Marks ",
  },
  highlights = {
    project_name = { fg = "#8fbcbb", bold = true },
    separator = { fg = "#4c566a" },
    mark_number = { fg = "#d08770", bold = true },
    mark_path = { fg = "#e5e9f0" },
  },
  keymaps = {
    add = "<leader>na",
    remove = "<leader>nr",
    menu = "<leader>nm",
    clear = "<leader>nc",
    show = "<leader>ns",
    goto = true, -- map <leader>1..9
  },
}

M.config = vim.deepcopy(defaults)
M.state = {
  current_project = nil,
  marks_by_project = {},
  autocmd_registered = false,
  namespace = vim.api.nvim_create_namespace("niply_highlights"),
}

local function camel(name)
  return name:gsub("_(.)", function(c)
    return c:upper()
  end):gsub("^%l", string.upper)
end

local function highlight_group(name)
  return "Niply" .. camel(name)
end

local function setup_highlights()
  for key, opts in pairs(M.config.highlights or {}) do
    vim.api.nvim_set_hl(0, highlight_group(key), vim.tbl_extend("force", opts, { default = true }))
  end
end

local function ensure_data_dir()
  if M.config.persist_marks then
    vim.fn.mkdir(M.config.data_dir, "p")
  end
end

local function safe_project_name(path)
  return (path or ""):gsub("[/\\:]", "_"):gsub("^_+", "")
end

local function get_marks_file(project_root)
  if not (M.config.persist_marks and project_root and project_root ~= "") then
    return nil
  end
  return string.format("%s/%s_marks.json", M.config.data_dir, safe_project_name(project_root))
end

local function detect_project_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  local start_dir = bufname ~= "" and vim.fs.dirname(bufname) or vim.fn.getcwd()

  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    local root = client.config and client.config.root_dir
    if root and root ~= "" then
      return vim.fs.normalize(root)
    end
  end

  local git_root = vim.fs.find(".git", { path = start_dir, upward = true, type = "directory" })[1]
  if git_root then
    return vim.fs.dirname(git_root)
  end

  return vim.fn.getcwd()
end

local function load_marks_from_disk(project)
  local file = get_marks_file(project)
  if not file or vim.fn.filereadable(file) == 0 then
    return {}
  end
  local ok, content = pcall(vim.fn.readfile, file)
  if not ok or #content == 0 then
    return {}
  end
  local ok2, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
  if not ok2 or type(data) ~= "table" then
    return {}
  end
  local filtered = {}
  for _, path in ipairs(data) do
    if vim.fn.filereadable(path) == 1 then
      table.insert(filtered, path)
    end
  end
  return filtered
end

local function save_marks_to_disk(project, marks)
  local file = get_marks_file(project)
  if not file then
    return
  end
  local ok, json = pcall(vim.fn.json_encode, marks)
  if not ok then
    vim.notify("Niply: failed to encode marks", vim.log.levels.ERROR)
    return
  end
  local ok2, err = pcall(vim.fn.writefile, { json }, file)
  if not ok2 or err == false then
    vim.notify("Niply: failed to write marks file", vim.log.levels.ERROR)
  end
end

local function get_marks()
  local project = detect_project_root()
  if M.state.current_project ~= project then
    if M.state.current_project and M.state.marks_by_project[M.state.current_project] then
      save_marks_to_disk(M.state.current_project, M.state.marks_by_project[M.state.current_project])
    end
    M.state.current_project = project
    if not M.state.marks_by_project[project] then
      M.state.marks_by_project[project] = load_marks_from_disk(project)
    end
  end
  return M.state.marks_by_project[project], project
end

local function normalize_path(path)
  return vim.fn.fnamemodify(path or "", ":p")
end

local function format_path(path)
  local formatted = vim.fn.fnamemodify(path, ":~:.")
  if not formatted or formatted == "" then
    formatted = path
  end
  return formatted
end

local function render_menu_lines(project, marks, width)
  local lines = {}
  table.insert(lines, string.format("Project: %s", vim.fn.fnamemodify(project, ":t")))
  table.insert(lines, string.rep("─", math.max(2, width - 2)))
  for idx, file in ipairs(marks) do
    local path = format_path(file)
    if #path > width - 8 then
      path = "..." .. path:sub(-(width - 11))
    end
    table.insert(lines, string.format("%d: %s", idx, path))
  end
  return lines
end

local function apply_menu_highlights(buf, marks)
  vim.api.nvim_buf_clear_namespace(buf, M.state.namespace, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, M.state.namespace, highlight_group("project_name"), 0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, M.state.namespace, highlight_group("separator"), 1, 0, -1)

  for idx = 1, #marks do
    local line = idx + 1
    local text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1] or ""
    local colon = text:find(":")
    if colon then
      vim.api.nvim_buf_add_highlight(buf, M.state.namespace, highlight_group("mark_number"), line, 0, colon)
      vim.api.nvim_buf_add_highlight(buf, M.state.namespace, highlight_group("mark_path"), line, colon + 1, -1)
    end
  end
end

local function open_menu()
  local marks, project = get_marks()
  if #marks == 0 then
    vim.notify("Niply: no marks in this project", vim.log.levels.INFO)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "niplymenu"

  local width = M.config.menu.width
  local height = math.min(#marks + 2, M.config.menu.height)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = M.config.menu.border,
    title = M.config.menu.title,
    title_pos = "center",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, render_menu_lines(project, marks, width))
  vim.bo[buf].modifiable = false
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_cursor(win, { 3, 0 })
  apply_menu_highlights(buf, marks)

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function open_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local index = cursor[1] - 2
    local file = marks[index]
    if file then
      close()
      vim.cmd.edit(vim.fn.fnameescape(file))
    else
      vim.notify("Niply: invalid selection", vim.log.levels.ERROR)
    end
  end

  local function refresh_buffer()
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, render_menu_lines(project, marks, width))
    vim.bo[buf].modifiable = false
    apply_menu_highlights(buf, marks)
    local cursor = vim.api.nvim_win_get_cursor(win)
    local max_line = #marks + 2
    if cursor[1] > max_line then
      vim.api.nvim_win_set_cursor(win, { max_line, 0 })
    end
  end

  local function remove_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local index = cursor[1] - 2
    if index < 1 or not marks[index] then
      return
    end
    local removed = table.remove(marks, index)
    save_marks_to_disk(project, marks)
    if #marks == 0 then
      close()
      vim.notify("Niply: no marks left", vim.log.levels.INFO)
      return
    end
    refresh_buffer()
    vim.notify("Niply: removed mark " .. format_path(removed), vim.log.levels.INFO)
  end

  local function move(direction)
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line = cursor[1]
    if direction == "up" and line > 3 then
      vim.api.nvim_win_set_cursor(win, { line - 1, 0 })
    elseif direction == "down" and line < #marks + 2 then
      vim.api.nvim_win_set_cursor(win, { line + 1, 0 })
    end
  end

  local mappings = {
    ["<CR>"] = open_at_cursor,
    o = open_at_cursor,
    ["<Space>"] = open_at_cursor,
    q = close,
    ["<Esc>"] = close,
    x = remove_at_cursor,
    dd = remove_at_cursor,
    ["<Del>"] = remove_at_cursor,
    j = function()
      move("down")
    end,
    k = function()
      move("up")
    end,
    ["<Down>"] = function()
      move("down")
    end,
    ["<Up>"] = function()
      move("up")
    end,
  }

  for lhs, rhs in pairs(mappings) do
    vim.keymap.set("n", lhs, rhs, { buffer = buf, noremap = true, silent = true, nowait = true })
  end

  for i = 1, math.min(#marks, 9) do
    vim.keymap.set("n", tostring(i), function()
      close()
      M.nav_file(i)
    end, { buffer = buf, noremap = true, silent = true, nowait = true })
  end
end

local function notify(msg, level)
  vim.notify("Niply: " .. msg, level or vim.log.levels.INFO)
end

function M.add_mark()
  local marks, project = get_marks()
  local file = normalize_path(vim.api.nvim_buf_get_name(0))
  if file == "" then
    notify("cannot mark unnamed buffer", vim.log.levels.WARN)
    return
  end
  for idx, path in ipairs(marks) do
    if path == file then
      notify(string.format("file already marked (#%d)", idx))
      return
    end
  end
  if #marks >= M.config.max_marks then
    notify("maximum marks reached (" .. M.config.max_marks .. ")", vim.log.levels.WARN)
    return
  end
  table.insert(marks, file)
  save_marks_to_disk(project, marks)
  notify("marked #" .. #marks .. ": " .. format_path(file))
end

function M.remove_mark()
  local marks, project = get_marks()
  local file = normalize_path(vim.api.nvim_buf_get_name(0))
  for idx, path in ipairs(marks) do
    if path == file then
      table.remove(marks, idx)
      save_marks_to_disk(project, marks)
      notify("unmarked: " .. format_path(file))
      return
    end
  end
  notify("file not in marks", vim.log.levels.WARN)
end

function M.nav_file(idx)
  local marks = get_marks()
  local target = marks[idx]
  if target then
    vim.cmd.edit(vim.fn.fnameescape(target))
  else
    notify(string.format("mark #%d does not exist", idx), vim.log.levels.ERROR)
  end
end

function M.clear_marks()
  local marks, project = get_marks()
  if #marks == 0 then
    notify("no marks to clear")
    return
  end
  local choice = vim.fn.confirm(string.format("Clear all %d marks?", #marks), "&Yes\n&No", 2)
  if choice == 1 then
    vim.tbl_clear(marks)
    save_marks_to_disk(project, marks)
    notify("cleared marks for project")
  end
end

function M.show_marks()
  local marks = get_marks()
  if #marks == 0 then
    notify("no marks in this project")
    return
  end
  local lines = { "Marks for " .. format_path(M.state.current_project) }
  for idx, file in ipairs(marks) do
    table.insert(lines, string.format("%d: %s", idx, format_path(file)))
  end
  notify(table.concat(lines, "\n"))
end

M.toggle_menu = open_menu

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
end

local function setup_keymaps()
  local maps = M.config.keymaps
  if maps == false then
    return
  end
  if maps.add then
    map(maps.add, M.add_mark, "Niply: add mark")
  end
  if maps.remove then
    map(maps.remove, M.remove_mark, "Niply: remove mark")
  end
  if maps.menu then
    map(maps.menu, M.toggle_menu, "Niply: quick menu")
  end
  if maps.clear then
    map(maps.clear, M.clear_marks, "Niply: clear marks")
  end
  if maps.show then
    map(maps.show, M.show_marks, "Niply: list marks")
  end
  if maps.goto then
    for i = 1, 9 do
      map(string.format("<leader>%d", i), function()
        M.nav_file(i)
      end, string.format("Niply: goto mark %d", i))
    end
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
  ensure_data_dir()
  setup_highlights()
  if M.config.persist_marks and not M.state.autocmd_registered then
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if M.state.current_project and M.state.marks_by_project[M.state.current_project] then
          save_marks_to_disk(M.state.current_project, M.state.marks_by_project[M.state.current_project])
        end
      end,
    })
    M.state.autocmd_registered = true
  end
  setup_keymaps()
end

return M
