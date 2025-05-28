return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup {
        custom_surroundings = {
          [')'] = { output = { left = '(', right = ')' } },
          [']'] = { output = { left = '[', right = ']' } },
        },
      }
      require('mini.pairs').setup()

      local statusline = require 'mini.statusline'

      local custom_fileinfo = function()
        local filetype = vim.bo.filetype
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        if filetype == '' then return '' end
        -- local fileformat = vim.bo.fileformat
        return string.format('%s/%s', filetype, encoding)
      end

      local git_status = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          local parts = {}
          if gitsigns.added and gitsigns.added > 0 then
            table.insert(parts, '%#MiniStatuslineGitAdd#+' .. gitsigns.added .. '%*')
          end
          if gitsigns.changed and gitsigns.changed > 0 then
            table.insert(parts, '%#MiniStatuslineGitChange#~' .. gitsigns.changed .. '%*')
          end
          if gitsigns.removed and gitsigns.removed > 0 then
            table.insert(parts, '%#MiniStatuslineGitRemove#-' .. gitsigns.removed .. '%*')
          end
          return table.concat(parts, ' ')
        else
          return ''
        end
      end

      statusline.setup {
        content = {
          active = function()
            local mode_map = {
              ['n'] = { 'N', 'MiniStatuslineModeNormal' },
              ['no'] = { 'N', 'MiniStatuslineModeNormal' },
              ['v'] = { 'V', 'MiniStatuslineModeVisual' },
              ['V'] = { 'VL', 'MiniStatuslineModeVisual' },
              [''] = { 'VB', 'MiniStatuslineModeVisual' },
              ['i'] = { 'I', 'MiniStatuslineModeInsert' },
              ['ic'] = { 'I', 'MiniStatuslineModeInsert' },
              ['ix'] = { 'I', 'MiniStatuslineModeInsert' },
              ['R'] = { 'R', 'MiniStatuslineModeReplace' },
              ['Rc'] = { 'R', 'MiniStatuslineModeReplace' },
              ['Rv'] = { 'Rv', 'MiniStatuslineModeReplace' },
              ['c'] = { 'C', 'MiniStatuslineModeCommand' },
              ['cv'] = { 'Ex', 'MiniStatuslineModeCommand' },
              ['ce'] = { 'Ex', 'MiniStatuslineModeCommand' },
              ['s'] = { 'S', 'MiniStatuslineModeVisual' },
              ['S'] = { 'S', 'MiniStatuslineModeVisual' },
              [''] = { 'SB', 'MiniStatuslineModeVisual' },
              ['t'] = { 'T', 'MiniStatuslineModeNormal' },
            }
            local current_mode = vim.api.nvim_get_mode().mode
            local mode_display, mode_hl = unpack(mode_map[current_mode] or { current_mode, 'MiniStatuslineModeNormal' })
            local location = '%2l:%-2v'
            local fileinfo = custom_fileinfo()
            local git = git_status()

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode_display } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = {
                vim.fn.expand('%:~:.')
              }
              },
              '%=',
              { strings = { git } },
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = 'MiniStatuslineLocation', strings = { location } },
            }
          end,
          inactive = function()
            return MiniStatusline.combine_groups {
              { hl = 'MiniStatuslineFilename', strings = { vim.fn.expand('%:~:.') } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { custom_fileinfo() } },
            }
          end,
        },
      }
    end,
  },
}
