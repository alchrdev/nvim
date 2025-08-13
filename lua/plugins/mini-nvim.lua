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
        return string.format('%s/%s', filetype, encoding)
      end

      local git_status = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if not gitsigns then return '' end

        local parts = {}

        if gitsigns.added and gitsigns.added > 0 then
          table.insert(parts,
            '%#GitBorderAdd#%*'
            .. '%#MiniStatuslineGitAdd#+'
            .. gitsigns.added
            .. '%*%#GitBorderAdd#%*'
          )
        end

        if gitsigns.changed and gitsigns.changed > 0 then
          table.insert(parts,
            '%#GitBorderChange#%*'
            .. '%#MiniStatuslineGitChange#~'
            .. gitsigns.changed
            .. '%*%#GitBorderChange#%*'
          )
        end

        if gitsigns.removed and gitsigns.removed > 0 then
          table.insert(parts,
            '%#GitBorderRemove#%*'
            .. '%#MiniStatuslineGitRemove#-'
            .. gitsigns.removed
            .. '%*%#GitBorderRemove#%*'
          )
        end

        return table.concat(parts, ' ')
      end

      statusline.setup {
        content = {
          active = function()
            local mode_map = {
              ['n']  = { 'N',  'MiniStatuslineModeNormal' },
              ['no'] = { 'N',  'MiniStatuslineModeNormal' },
              ['v']  = { 'V',  'MiniStatuslineModeVisual' },
              ['V']  = { 'VL', 'MiniStatuslineModeVisual' },
              ['\22'] = { 'VB', 'MiniStatuslineModeVisual' },
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
              ['\19'] = { 'SB', 'MiniStatuslineModeVisual' },
              ['t']  = { 'T',  'MiniStatuslineModeNormal' },
            }

            local current_mode = vim.api.nvim_get_mode().mode
            local mode_display, mode_hl = unpack(mode_map[current_mode] or { current_mode, 'MiniStatuslineModeNormal' })

            local filename = vim.fn.expand('%:~:.')
            local location = '%2l:%-2v'
            local fileinfo = custom_fileinfo()
            local git = git_status()

            local function get_git_branch()
              local branch = vim.b.gitsigns_head or (vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head)
              if not branch then
                local ok, result = pcall(vim.fn.systemlist, 'git rev-parse --abbrev-ref HEAD')
                if ok and result and result[1] and not result[1]:match('^fatal') then
                  branch = result[1]
                end
              end
              return branch or ''
            end

            local branch = get_git_branch()

            -- Spacing configuration
            local spacing = {
              between_pills = ' ', -- Space between right-side pills
              after_git = '  ',    -- Space after git status
            }

            -- Build right section as a single string
            local right_parts = {}

            -- Git status (with conditional space)
            if git ~= '' then
              table.insert(right_parts, git .. spacing.after_git)
            end

            -- Right-side pills (with restored curved borders)
            local pills = {

              -- Branch pill
              '%#MiniStatuslineBranchBorder#%*'
                .. '%#MiniStatuslineBranch# ' .. branch .. '%*'
                .. '%#MiniStatuslineBranchBorder#%*',

              -- Fileinfo pill  
              '%#MiniStatuslineFileinfoBorder#%*'
                .. '%#MiniStatuslineFileinfo#' .. fileinfo .. '%*'
                .. '%#MiniStatuslineFileinfoBorder#%*',

              -- Location pill
              '%#MiniStatuslineLocationBorder#%*'
                .. '%#MiniStatuslineLocation#' .. location .. '%*'
                .. '%#MiniStatuslineLocationBorder#%*',
            }

            -- Join pills with configured spacing
            table.insert(right_parts, table.concat(pills, spacing.between_pills))

            local right_section = table.concat(right_parts, '')

            return MiniStatusline.combine_groups {
              {
                strings = {
                  '%#MiniStatuslineModeBorder#%*'
                    .. '%#' .. mode_hl .. '#' .. mode_display .. '%*'
                    .. '%#MiniStatuslineModeBorder#%*',
                }
              },
              {
                -- Filename pill (with restored curved borders)
                strings = {
                  '%#MiniStatuslineFilenameBorder#%*'
                    .. '%#MiniStatuslineFilename#' .. filename .. '%*'
                    .. '%#MiniStatuslineFilenameBorder#%*',
                }
              },
              '', -- clear separation from filename
              '%=',

              -- Entire right section as a single group
              { strings = { right_section } },
            }
          end,

          inactive = function()
            local filename = vim.fn.expand('%:~:.')
            local fileinfo = custom_fileinfo()
            return MiniStatusline.combine_groups {
              {
                strings = {
                  '%#MiniStatuslineInactiveFilenameBorder#%*'
                    .. '%#MiniStatuslineInactiveFilename#' .. filename .. '%*'
                    .. '%#MiniStatuslineInactiveFilenameBorder#%*',
                }
              },
              '%=',
              {
                strings = {
                  '%#MiniStatuslineInactiveFileinfoBorder#%*'
                    .. '%#MiniStatuslineInactiveFileinfo#' .. fileinfo .. '%*'
                    .. '%#MiniStatuslineInactiveFileinfoBorder#%*',
                }
              },
            }

          end,
        },
      }
    end,
  },
}
