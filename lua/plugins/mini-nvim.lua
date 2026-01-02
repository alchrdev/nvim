return {
  {
    'nvim-mini/mini.nvim',
    config = function()
      ---------------------------------------------------------------------------
      -- MINI.NVIM
      ---------------------------------------------------------------------------
      require('mini.surround').setup {
        custom_surroundings = {
          [')'] = { output = { left = '(', right = ')' } },
          [']'] = { output = { left = '[', right = ']' } },
        },
      }

      require('mini.pairs').setup()

      local statusline = require('mini.statusline')

      ---------------------------------------------------------------------------
      -- HELPERS
      ---------------------------------------------------------------------------
      local function pad(s)
        return ' ' .. (s or '') .. ' '
      end

      ---------------------------------------------------------------------------
      -- SEGMENT: Renderiza texto con highlight group específico
      ---------------------------------------------------------------------------
      local function segment(group, text)
        text = tostring(text or '')
        if text == '' then return '' end
        return '%#' .. group .. '#' .. pad(text) .. '%*'
      end

      ---------------------------------------------------------------------------
      -- CUSTOM FILEINFO
      ---------------------------------------------------------------------------
      local function custom_fileinfo()
        local ft  = vim.bo.filetype
        local enc = vim.bo.fileencoding or vim.bo.encoding
        if ft == '' then return '' end
        return ft .. '/' .. enc
      end

      ---------------------------------------------------------------------------
      -- GIT BRANCH
      ---------------------------------------------------------------------------
      local function get_git_branch()
        local head = vim.b.gitsigns_head
          or (vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head)

        if head and head ~= '' then return head end

        local ok, out = pcall(vim.fn.systemlist, 'git rev-parse --abbrev-ref HEAD')
        if ok and out and out[1] and not out[1]:match('^fatal') then
          return out[1]
        end

        return ''
      end

      ---------------------------------------------------------------------------
      -- GIT STATUS
      ---------------------------------------------------------------------------
      local function git_status()
        local gs = vim.b.gitsigns_status_dict
        if not gs then return '' end

        local parts = {}

        if (gs.added or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitAdd', '+' .. gs.added))
        end
        if (gs.changed or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitChange', '~' .. gs.changed))
        end
        if (gs.removed or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitRemove', '-' .. gs.removed))
        end

        return table.concat(parts, ' ')
      end

      ---------------------------------------------------------------------------
      -- STATUSLINE
      ---------------------------------------------------------------------------
      statusline.setup {
        content = {
          active = function()
            local mode_map = {
              ['n']  = { 'N',  'MiniStatuslineModeNormal' },
              ['no'] = { 'N',  'MiniStatuslineModeNormal' },
              ['v']  = { 'V',  'MiniStatuslineModeVisual' },
              ['V']  = { 'VL', 'MiniStatuslineModeVisual' },
              ['\22']= { 'VB', 'MiniStatuslineModeVisual' },
              ['i']  = { 'I',  'MiniStatuslineModeInsert' },
              ['ic'] = { 'I',  'MiniStatuslineModeInsert' },
              ['ix'] = { 'I',  'MiniStatuslineModeInsert' },
              ['R']  = { 'R',  'MiniStatuslineModeReplace' },
              ['Rc'] = { 'R',  'MiniStatuslineModeReplace' },
              ['Rv'] = { 'Rv', 'MiniStatuslineModeReplace' },
              ['c']  = { 'C',  'MiniStatuslineModeCommand' },
              ['cv'] = { 'Ex', 'MiniStatuslineModeCommand' },
              ['ce'] = { 'Ex', 'MiniStatuslineModeCommand' },
              ['s']  = { 'S',  'MiniStatuslineModeVisual' },
              ['S']  = { 'S',  'MiniStatuslineModeVisual' },
              ['\19']= { 'SB', 'MiniStatuslineModeVisual' },
              ['t']  = { 'T',  'MiniStatuslineModeNormal' },
            }

            local mode = vim.api.nvim_get_mode().mode
            local mode_display, mode_hl =
              unpack(mode_map[mode] or { mode, 'MiniStatuslineModeNormal' })

            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end

            local location = '%2l:%-2v'
            local fileinfo = custom_fileinfo()
            local git      = git_status()
            local branch   = get_git_branch()

            local right_parts = {}

            if git ~= '' then table.insert(right_parts, git) end

            local pills = {}
            if branch ~= '' then
              table.insert(pills, segment('MiniStatuslineBranch', ' ' .. branch))
            end

            table.insert(pills, segment('MiniStatuslineFileinfo', fileinfo))
            table.insert(pills, segment('MiniStatuslineLocation', location))

            table.insert(right_parts, table.concat(pills, ' '))
            local right_section = table.concat(right_parts, '  ')

            return statusline.combine_groups {
              { strings = { segment(mode_hl, mode_display) } },
              { strings = { segment('MiniStatuslineFilename', filename) } },
              '',
              '%=',
              { strings = { right_section } },
            }
          end,

          inactive = function()
            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end

            local fileinfo = custom_fileinfo()

            return statusline.combine_groups {
              { strings = { segment('MiniStatuslineInactiveFilename', filename) } },
              '%=',
              { strings = { segment('MiniStatuslineInactiveFileinfo', fileinfo) } },
            }
          end,
        },
      }

      require('mini.move').setup()
      require('mini.indentscope').setup()
      require('mini.bracketed').setup()
    end,
  },
}
