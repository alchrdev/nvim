local user_dir = vim.fn.stdpath('config') .. '/lua/user'
local scan = vim.loop.fs_scandir(user_dir)

while scan do
  local name, filetype = vim.loop.fs_scandir_next(scan)
  if not name then break end

  if filetype == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
    local module = name:gsub('%.lua$', '')
    local ok, mod = pcall(require, 'user.' .. module)
    if ok and type(mod) == 'table' and type(mod.setup) == 'function' then
      mod.setup()
    end
  end
end
