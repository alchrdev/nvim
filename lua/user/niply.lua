local vim = vim

local niply = {}

-- Store marks by project
local marks_by_project = {}

-- Current detected project
local current_project = nil

-- Default configuration
local config = {
  max_marks = 10,
  persist_marks = true,
  data_dir = vim.fn.stdpath("data") .. "/niply/",
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
  }
}

-- Configure custom highlights
local function setup_highlights()
  for name, opts in pairs(config.highlights) do
    local hl_name = "Niply" .. name:gsub("_(.)", function(c) return c:upper() end):gsub("^%l", string.upper)
    vim.api.nvim_set_hl(0, hl_name, vim.tbl_extend("force", opts, { default = true }))
  end
end

-- Create data directory if it doesn't exist
local function ensure_data_dir()
  if config.persist_marks then
    vim.fn.mkdir(config.data_dir, "p")
  end
end

-- Detect project root using modern vim.fs functions
local function get_project_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()

  -- Try to detect using LSP first
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 and clients[1].config.root_dir then
    return clients[1].config.root_dir
  end

  -- Use vim.fs.find for more efficient detection
  local git_root = vim.fs.find(".git", {
    path = current_dir,
    upward = true,
    type = "directory"
  })[1]

  if git_root then
    return vim.fs.dirname(git_root)
  end

  -- Fallback to cwd
  return vim.fn.getcwd()
end

-- Generate filename for persistence
local function get_marks_filename(project_root)
  if not config.persist_marks then
    return nil
  end

  local safe_name = project_root:gsub("[/\\:]", "_"):gsub("^_+", "")
  return config.data_dir .. safe_name .. "_marks.json"
end

-- Load marks from file with better error handling
local function load_marks(project_root)
  local filename = get_marks_filename(project_root)
  if not filename or vim.fn.filereadable(filename) == 0 then
    return {}
  end

  local ok, content = pcall(vim.fn.readfile, filename)
  if not ok or #content == 0 then
    return {}
  end

  local ok2, marks = pcall(vim.fn.json_decode, table.concat(content, "\n"))
  if not ok2 or type(marks) ~= "table" then
    return {}
  end

  -- Filter files that no longer exist
  local valid_marks = {}
  for _, mark in ipairs(marks) do
    if vim.fn.filereadable(mark) == 1 then
      table.insert(valid_marks, mark)
    end
  end

  return valid_marks
end

-- Save marks to file with better error handling
local function save_marks(project_root, marks)
  local filename = get_marks_filename(project_root)
  if not filename then
    return
  end

  local ok, json = pcall(vim.fn.json_encode, marks)
  if not ok then
    vim.notify("Niply: Error encoding marks to JSON", vim.log.levels.ERROR)
    return
  end

  local ok2 = pcall(vim.fn.writefile, { json }, filename)
  if not ok2 then
    vim.notify("Niply: Error saving marks to file", vim.log.levels.ERROR)
  end
end

-- Get marks for active project, initialize if it doesn't exist
local function get_marks()
  local project = get_project_root()
  if current_project ~= project then
    -- Save marks from previous project if there were changes
    if current_project and marks_by_project[current_project] then
      save_marks(current_project, marks_by_project[current_project])
    end
    current_project = project
    if not marks_by_project[current_project] then
      marks_by_project[current_project] = load_marks(current_project)
    end
  end
  return marks_by_project[current_project]
end

-- Normalize file path
local function normalize_path(file)
  return vim.fn.fnamemodify(file, ":p")
end

-- Add file to marks
function niply.add_file()
  local marks = get_marks()
  local file = normalize_path(vim.api.nvim_buf_get_name(0))

  -- Verify that the file is not empty
  if file == "" or file == normalize_path("") then
    vim.notify("Niply: Cannot mark unnamed buffer", vim.log.levels.WARN)
    return
  end

  -- Check if it already exists
  for i, v in ipairs(marks) do
    if v == file then
      vim.notify("Niply: File already marked (#" .. i .. ")", vim.log.levels.INFO)
      return
    end
  end

  -- Check marks limit
  if #marks >= config.max_marks then
    vim.notify("Niply: Maximum marks reached (" .. config.max_marks .. ")", vim.log.levels.WARN)
    return
  end

  table.insert(marks, file)
  save_marks(current_project, marks)

  local relative_path = vim.fn.fnamemodify(file, ":~:.")
  if not relative_path or relative_path == "" then
    relative_path = file -- Fallback to full path
  end

  vim.notify("Niply: Marked file #" .. #marks .. ": " .. relative_path, vim.log.levels.INFO)
end

-- Remove file from marks
function niply.remove_file()
  local marks = get_marks()
  local file = normalize_path(vim.api.nvim_buf_get_name(0))

  for i, v in ipairs(marks) do
    if v == file then
      table.remove(marks, i)
      save_marks(current_project, marks)
      vim.notify("Niply: Unmarked file: " .. vim.fn.fnamemodify(file, ":~:."), vim.log.levels.INFO)
      return
    end
  end

  vim.notify("Niply: File not in marks", vim.log.levels.WARN)
end

-- Open quick marks menu with optimized rendering
local function open_quick_menu()
  local marks = get_marks()
  if #marks == 0 then
    vim.notify("Niply: No marked files in this project.", vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local width = config.menu.width
  local height = math.min(#marks + 2, config.menu.height)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = config.menu.border,
    title = config.menu.title,
    title_pos = "center",
  }

  -- Set buffer options using modern vim.bo
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'niplymenu'
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true

  local display_lines = {}
  local project_name = vim.fn.fnamemodify(current_project, ":t")
  table.insert(display_lines, "Project: " .. project_name)
  table.insert(display_lines, string.rep("─", width - 2))

  for i, file in ipairs(marks) do
    local relative_path = vim.fn.fnamemodify(file, ":~:.")
    if not relative_path then
      relative_path = file
    end
    local display_path = relative_path
    if #display_path > width - 8 then
      display_path = "..." .. display_path:sub(-(width - 11))
    end
    table.insert(display_lines, string.format("%d: %s", i, display_path))
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_lines)

  -- Apply highlights using nvim_buf_add_highlight
  local ns_id = vim.api.nvim_create_namespace("niply_highlights")

  -- Project name highlight
  vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyProjectName", 0, 0, -1)
  -- Separator highlight
  vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplySeparator", 1, 0, -1)

  -- Mark highlights
  for i, _ in ipairs(marks) do
    local line_idx = i + 1 -- +1 because marks start at line 3 (index 2)
    local line_text = display_lines[line_idx + 1]
    local colon_pos = line_text:find(":")
    if colon_pos then
      vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyMarkNumber", line_idx, 0, colon_pos)
      vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyMarkPath", line_idx, colon_pos + 1, -1)
    end
  end

  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, opts)
  -- Position cursor on first mark (line 3)
  vim.api.nvim_win_set_cursor(win, {3, 0})

  local function close_menu()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function open_file()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line_nr = cursor[1] - 2 -- Adjust for header
    if line_nr < 1 then
      line_nr = 1
    end
    local file = marks[line_nr]
    if file then
      close_menu()
      vim.cmd("edit " .. vim.fn.fnameescape(file))
    else
      vim.notify("Niply: Invalid selection", vim.log.levels.ERROR)
    end
  end

  local function delete_mark()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line_nr = cursor[1] - 2 -- Adjust for header
    if line_nr < 1 then
      return
    end

    if marks[line_nr] then
      local removed_file = table.remove(marks, line_nr)
      save_marks(current_project, marks)

      if #marks == 0 then
        close_menu()
        vim.notify("Niply: No more marks in this project.", vim.log.levels.INFO)
        return
      end

      -- Update buffer efficiently
      vim.bo[buf].modifiable = true

      local new_lines = {"Project: " .. vim.fn.fnamemodify(current_project, ":t"), string.rep("─", width - 2)}
      for i, file in ipairs(marks) do
        local relative_path = vim.fn.fnamemodify(file, ":~:.")
        if not relative_path then
          relative_path = file
        end
        local display_path = relative_path
        if #display_path > width - 8 then
          display_path = "..." .. display_path:sub(-(width - 11))
        end
        table.insert(new_lines, string.format("%d: %s", i, display_path))
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)

      -- Reapply highlights efficiently
      vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
      vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyProjectName", 0, 0, -1)
      vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplySeparator", 1, 0, -1)

      for i, _ in ipairs(marks) do
        local line_idx = i + 1
        local line_text = new_lines[line_idx + 1]
        local colon_pos = line_text:find(":")
        if colon_pos then
          vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyMarkNumber", line_idx, 0, colon_pos)
          vim.api.nvim_buf_add_highlight(buf, ns_id, "NiplyMarkPath", line_idx, colon_pos + 1, -1)
        end
      end

      vim.bo[buf].modifiable = false

      -- Adjust cursor if last line was deleted
      local pos = (line_nr > #marks) and (#marks + 2) or (line_nr + 2)
      vim.api.nvim_win_set_cursor(win, {pos, 0})

      if removed_file then
        local file_name = vim.fn.fnamemodify(removed_file, ":t")
        if not file_name then
          file_name = removed_file
        end
        vim.notify("Niply: Removed mark: " .. file_name, vim.log.levels.INFO)
      end
    end
  end

  local function move_cursor(direction)
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line_nr = cursor[1]
    local min_line = 3
    local max_line = #marks + 2

    if direction == "up" and line_nr > min_line then
      vim.api.nvim_win_set_cursor(win, {line_nr - 1, 0})
    elseif direction == "down" and line_nr < max_line then
      vim.api.nvim_win_set_cursor(win, {line_nr + 1, 0})
    end
  end

  -- Optimized keymap setup
  local keymaps = {
    ['<CR>'] = open_file,
    ['o'] = open_file,
    ['<Space>'] = open_file,
    ['dd'] = delete_mark,
    ['x'] = delete_mark,
    ['<Del>'] = delete_mark,
    ['q'] = close_menu,
    ['<Esc>'] = close_menu,
    ['j'] = function() move_cursor("down") end,
    ['k'] = function() move_cursor("up") end,
    ['<Down>'] = function() move_cursor("down") end,
    ['<Up>'] = function() move_cursor("up") end,
  }

  for key, func in pairs(keymaps) do
    vim.keymap.set('n', key, func, {
      nowait = true,
      noremap = true,
      silent = true,
      buffer = buf,
    })
  end

  -- Add numbers for direct navigation
  for i = 1, math.min(#marks, 9) do
    vim.keymap.set('n', tostring(i), function()
        close_menu()
        niply.nav_file(i)
      end, {
      nowait = true,
      noremap = true,
      silent = true,
      buffer = buf,
    })
  end
end

niply.toggle_quick_menu = open_quick_menu

-- Navigate to file by index
function niply.nav_file(idx)
  local marks = get_marks()
  local file = marks[idx]
  if file then
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  else
    vim.notify("Niply: Mark #" .. idx .. " does not exist in this project.", vim.log.levels.ERROR)
  end
end

-- Clear all marks with improved confirmation
function niply.clear_all_marks()
  local marks = get_marks()
  local count = #marks
  if count == 0 then
    vim.notify("Niply: No marks to clear in this project.", vim.log.levels.INFO)
    return
  end

  -- Use vim.fn.confirm for compatibility
  local prompt_text = "Clear all " .. tostring(count) .. " marks for this project?"
  local choice = vim.fn.confirm(prompt_text, "&Yes\n&No", 2)
  if choice == 1 then
    vim.tbl_clear(marks) -- Efficient way to empty the table
    save_marks(current_project, marks)
    vim.notify("Niply: Cleared " .. count .. " marks for this project.", vim.log.levels.INFO)
  end
end

-- Show marks information
function niply.show_marks()
  local marks = get_marks()
  if #marks == 0 then
    vim.notify("Niply: No marks in this project.", vim.log.levels.INFO)
    return
  end

  local project_name = vim.fn.fnamemodify(current_project, ":t")
  local lines = {"Niply Marks for project: " .. project_name, ""}

  for i, file in ipairs(marks) do
    local relative_path = vim.fn.fnamemodify(file, ":~:.")
    if not relative_path then
      relative_path = file
    end
    table.insert(lines, string.format("%d: %s", i, relative_path))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Configure Niply
function niply.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)
  ensure_data_dir()
  setup_highlights()

  -- Save marks when exiting Neovim
  if config.persist_marks then
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if current_project and marks_by_project[current_project] then
          save_marks(current_project, marks_by_project[current_project])
        end
      end,
    })
  end
end

-- Default configuration
niply.setup()

-- Default keymaps
vim.keymap.set('n', '<leader>na', niply.add_file, { desc = 'Niply: Mark file' })
vim.keymap.set('n', '<leader>nr', niply.remove_file, { desc = 'Niply: Remove mark' })
vim.keymap.set('n', '<leader>nm', niply.toggle_quick_menu, { desc = 'Niply: Quick menu' })
vim.keymap.set('n', '<leader>nc', niply.clear_all_marks, { desc = 'Niply: Clear all marks' })
vim.keymap.set('n', '<leader>ns', niply.show_marks, { desc = 'Niply: Show marks' })

-- Quick navigation by numbers
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() niply.nav_file(i) end, {
    desc = 'Niply: Go to mark ' .. i
  })
end

return niply
