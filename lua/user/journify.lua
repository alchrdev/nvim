-- Open or create daily notes based on date navigation

_G.current_navigation_date = nil

--- @param date_str string Date in YYYY-MM-DD format
--- @return string
local function get_formatted_datetime(date_str)
  local day_names = { "domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado" }
  local month_names = { "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre" }

  local current_time = os.time()
  local year, month, day = date_str:match("^(%d+)%-(%d+)%-(%d+)$")
  local date_table = {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(os.date("%H", current_time)),
    min = tonumber(os.date("%M", current_time)),
    sec = tonumber(os.date("%S", current_time))
  }
  local timestamp = os.time(date_table)
  local day_name = day_names[tonumber(os.date("%w", timestamp)) + 1]
  local hour = tonumber(os.date("%I", current_time))
  local minute = os.date("%M", current_time)
  local second = os.date("%S", current_time)
  local am_pm = os.date("%p", current_time) == "AM" and "AM" or "PM"

  return string.format("> 📓 %s, %02d de %s del año %s a las %02d:%s:%s %s",
    day_name, tonumber(day), month_names[tonumber(month)], year, hour, minute, second, am_pm)
end

--- @return string
local function get_current_date_for_notes()
  local result = os.date("%Y-%m-%d")
  assert(type(result) == "string", "Expected os.date to return a string")
  return result
end

--- @param date_str string
--- @return table
local function parse_date(date_str)
  local year, month, day = date_str:match("^(%d+)%-(%d+)%-(%d+)$")
  return { year = tonumber(year), month = tonumber(month), day = tonumber(day) }
end

--- @param current_date string
--- @param offset_days number
--- @return string
local function get_relative_date(current_date, offset_days)
  local date_table = parse_date(current_date)
  local timestamp = os.time(date_table) + (offset_days * 24 * 60 * 60)
  local result = os.date("%Y-%m-%d", timestamp)
  assert(type(result) == "string", "Expected os.date to return a string")
  return result
end

--- @param current_date string
--- @return string
local function get_previous_date(current_date)
  return get_relative_date(current_date, -1)
end

--- @param current_date string
--- @return string
local function get_next_date(current_date)
  return get_relative_date(current_date, 1)
end

--- @param date string
local function open_or_create_note_for_date(date)
  _G.current_navigation_date = date
  local root_dir = vim.fn.getcwd()
  local folder_path = root_dir .. "/apsn/dly/"

  if vim.fn.isdirectory(folder_path) ~= 1 then
    vim.notify("Error: Folder 'apsn' not found in root directory", vim.log.levels.ERROR)
    return
  end

  local file_name = folder_path .. "/" .. date .. ".md"
  -- Normalize the path using vim.fn.fnamemodify and force consistent separators.
  file_name = vim.fn.fnamemodify(file_name, ":p")
  local sep = package.config:sub(1,1)
  file_name = file_name:gsub("[/\\]", sep)

  local file = io.open(file_name, "r")
  if file then
    file:close()
    vim.cmd("edit " .. vim.fn.fnameescape(file_name))
  else
    local new_file = io.open(file_name, "w")
    if new_file then
      new_file:write("---\n")
      new_file:write("mood:\n")
      new_file:write("location:\n")
      new_file:write("weather:\n")
      new_file:write("bed_time:\n")
      new_file:write("sleep_hours:\n")
      new_file:write("nap_hours:\n")
      new_file:write("get_up:\n")
      new_file:write("flow_state:\n")
      new_file:write("---\n\n")
      new_file:write(get_formatted_datetime(date) .. "\n\n")
      new_file:close()
      vim.cmd("edit " .. vim.fn.fnameescape(file_name))
      vim.notify("Daily note created: " .. vim.fn.fnamemodify(file_name, ":t"), vim.log.levels.INFO)
    else
      vim.notify("Error creating file: " .. file_name, vim.log.levels.ERROR)
    end
  end
end

vim.keymap.set('n', '<leader>ot', function()
  _G.current_navigation_date = nil  -- Reset navigation date
  local current_date = get_current_date_for_notes()
  open_or_create_note_for_date(current_date)
end, { desc = "[O]pen Today's note" })

vim.keymap.set('n', '<leader>op', function()
  local base_date = _G.current_navigation_date or get_current_date_for_notes()
  local previous_date = get_previous_date(base_date)
  open_or_create_note_for_date(previous_date)
end, { desc = "[O]pen Previous day's note" })

vim.keymap.set('n', '<leader>on', function()
  local base_date = _G.current_navigation_date or get_current_date_for_notes()
  local next_date = get_next_date(base_date)
  open_or_create_note_for_date(next_date)
end, { desc = "[O]pen Next day's note" })

return {
  get_formatted_datetime = get_formatted_datetime,
  get_current_date_for_notes = get_current_date_for_notes,
  parse_date = parse_date,
  get_relative_date = get_relative_date,
  get_previous_date = get_previous_date,
  get_next_date = get_next_date,
  open_or_create_note_for_date = open_or_create_note_for_date
}
