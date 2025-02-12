-- Generate new ID and update YAML header with it

local function generate_new_id()
  return os.date("%Y") .. os.date("%d") .. os.date("%H%M")
end

local function update_yaml_header()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local new_id = generate_new_id()
  local yaml_start, yaml_end = nil, nil

  -- Detect YAML block
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
    -- Update 'id' field if YAML block exists
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
    -- Add new YAML block if missing
    table.insert(lines, 1, "---")
    table.insert(lines, 2, "id: " .. new_id)
    table.insert(lines, 3, "---")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.notify("YAML header updated with new ID!")
end

vim.keymap.set('n', '<leader>uy', update_yaml_header, { desc = '[U]pdate [Y]AML header with ID' })


-- Global search and replace across the project

-- -- Función para obtener la fecha actual (puedes usarla en otro contexto si lo requieres)
-- local function get_current_date()
--   return os.date("%Y-%m-%d")
-- end

-- Función auxiliar para depuración
local function debug(message)
  local DEBUG_MODE = false
  if DEBUG_MODE then
    vim.notify(message, vim.log.levels.DEBUG)
  end
end

-- Función para detectar si estamos en Windows
local function is_windows()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

-- Función para buscar la ruta de ripgrep (rg) en el sistema
local function find_rg()
  local cmd
  if is_windows() then
    cmd = "where rg"
  else
    cmd = "command -v rg"
  end
  local handle = io.popen(cmd)
  if not handle then return "" end
  local output = handle:read("*a") or ""
  handle:close()
  return output:gsub("%s+", "")
end

-- Función para leer un archivo y devolver sus líneas en una tabla
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

-- Función para escribir líneas de vuelta en un archivo
local function write_file_lines(filepath, lines)
  local f = io.open(filepath, "w")
  if not f then
    vim.notify("Error al escribir en el archivo: " .. filepath, vim.log.levels.ERROR)
    return false
  end
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  return true
end

-- Función que realiza el reemplazo en el bloque YAML
-- Se asume que el YAML está delimitado por líneas que contengan únicamente '---'
local function replace_in_yaml(lines, search_term, replacement)
  local in_yaml = false
  local total_replacements = 0
  for i, line in ipairs(lines) do
    if line:match("^%s*---%s*$") then
      -- Alterna el estado al encontrar un delimitador
      in_yaml = not in_yaml
    elseif in_yaml then
      local new_line, count = line:gsub(search_term, replacement)
      if count > 0 then
        lines[i] = new_line
        total_replacements = total_replacements + count
      end
    end
  end
  return total_replacements
end

--------------------------------------------------------------------------------
-- Función Global Replace: Recorre archivos en el proyecto que tengan YAML
--------------------------------------------------------------------------------
local function global_replace()
  -- Pedir términos al usuario
  local search_term = vim.fn.input("Ingrese término de búsqueda: ")
  if search_term == "" then
    vim.notify("Operación cancelada: el término de búsqueda no puede estar vacío.", vim.log.levels.WARN)
    return
  end

  local replacement = vim.fn.input("Ingrese reemplazo: ")
  if replacement == "" then
    vim.notify("Operación cancelada: el reemplazo no puede estar vacío.", vim.log.levels.WARN)
    return
  end

  -- Obtener directorio raíz del proyecto
  local project_root = vim.fn.getcwd()
  debug("Directorio del proyecto: " .. project_root)

  -- Comprobar si ripgrep (rg) está en el PATH
  local rg_path = find_rg()
  if rg_path == "" then
    vim.notify("Ripgrep (rg) no se encontró en PATH. Instálalo para usar esta función.", vim.log.levels.ERROR)
    return
  end
  debug("Ripgrep encontrado: " .. rg_path)

  -- Comando para buscar archivos Markdown que contengan delimitadores YAML (---)
  local rg_cmd = string.format('rg -l "^%s$" --glob "*.md" --no-ignore', "---")
  debug("Comando de búsqueda: " .. rg_cmd)

  local file_handle = io.popen(rg_cmd)
  if not file_handle then
    vim.notify("Error al ejecutar el comando de búsqueda.", vim.log.levels.ERROR)
    return
  end

  local files = {}
  for file in file_handle:lines() do
    table.insert(files, file)
  end
  file_handle:close()

  if #files == 0 then
    vim.notify("No se encontraron archivos con YAML frontmatter.", vim.log.levels.INFO)
    return
  end

  local updated_files = 0
  for _, file in ipairs(files) do
    debug("Procesando archivo: " .. file)
    local lines = read_file_lines(file)
    if lines then
      local replacements = replace_in_yaml(lines, search_term, replacement)
      if replacements > 0 then
        if write_file_lines(file, lines) then
          vim.notify(string.format("Archivo actualizado: %s (se realizaron %d reemplazos)", file, replacements), vim.log.levels.INFO)
          updated_files = updated_files + 1
        end
      else
        debug("No se encontraron coincidencias en: " .. file)
      end
    else
      vim.notify("Error al leer el archivo: " .. file, vim.log.levels.ERROR)
    end
  end

  if updated_files == 0 then
    vim.notify("No se actualizó metadata YAML en ningún archivo.", vim.log.levels.INFO)
  else
    vim.notify("Actualización global completada exitosamente.", vim.log.levels.INFO)
  end

  -- Recargar buffers para reflejar cambios
  vim.cmd('bufdo e')
end

--------------------------------------------------------------------------------
-- Función Buffer Replace: Reemplaza solo en el YAML del archivo actual
--------------------------------------------------------------------------------
local function buffer_replace()
  local search_term = vim.fn.input("Ingrese término de búsqueda: ")
  if search_term == "" then
    vim.notify("Operación cancelada: el término de búsqueda no puede estar vacío.", vim.log.levels.WARN)
    return
  end

  local replacement = vim.fn.input("Ingrese reemplazo: ")
  if replacement == "" then
    vim.notify("Operación cancelada: el reemplazo no puede estar vacío.", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t')
  debug("Archivo actual: " .. file_path)

  local lines = read_file_lines(file_path)
  if not lines then
    vim.notify("Error al leer el archivo actual.", vim.log.levels.ERROR)
    return
  end

  local replacements = replace_in_yaml(lines, search_term, replacement)
  if replacements > 0 then
    if write_file_lines(file_path, lines) then
      vim.notify(string.format("Archivo %s actualizado: '%s' → '%s' (%d reemplazos)", file_name, search_term, replacement, replacements), vim.log.levels.INFO)
    end
  else
    vim.notify("No se encontraron coincidencias en el YAML de " .. file_name, vim.log.levels.INFO)
  end

  -- Recargar el buffer actual para reflejar los cambios
  vim.cmd('edit')
end

--------------------------------------------------------------------------------
-- Registro de comandos y keymaps
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command('GlobalReplace', global_replace, {})
vim.api.nvim_create_user_command('BufferReplace', buffer_replace, {})

vim.keymap.set('n', '<leader>gr', global_replace, { desc = "[G]lobal [R]eplace en YAML" })
vim.keymap.set('n', '<leader>br', buffer_replace, { desc = "[B]uffer [R]eplace en YAML" })
