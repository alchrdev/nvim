return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Surrounds & pairs
      require('mini.surround').setup {
        custom_surroundings = {
          [')'] = { output = { left = '(', right = ')' } },
          [']'] = { output = { left = '[', right = ']' } },
        },
      }
      require('mini.pairs').setup()

      local statusline = require('mini.statusline')

      -- Helpers ---------------------------------------------------------------
      local function pad(s) return ' ' .. (s or '') .. ' ' end

      -- Cache de grupos "Flat" sin fondo
      vim.g._ashen_flat_cache = vim.g._ashen_flat_cache or {}

      local function ensure_flat_group(group)
        local flat = group .. 'Flat'
        if not vim.g._ashen_flat_cache[flat] then
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
          if ok and hl then
            vim.api.nvim_set_hl(0, flat, {
              fg = hl.fg, bg = 'NONE',
              bold = hl.bold or false,
              italic = hl.italic or false,
              underline = hl.underline or false,
            })
          else
            -- fallback, al menos enlaza
            vim.api.nvim_set_hl(0, flat, { link = group })
          end
          vim.g._ashen_flat_cache[flat] = true
        end
        return flat
      end

      -- Segmento condicionado a transparencia:
      -- - Transparente: píldoras ( ) salvo que opts.force_flat=true
      -- - Sólido: siempre plano + sin fondo (usa grupo ...Flat)
      local function segment(group, text, border_group, opts)
        text = tostring(text or '')
        if text == '' then return '' end
        opts = opts or {}
        local transparent = vim.g.ashen_transparent

        if transparent and not opts.force_flat then
          return table.concat({
            '%#' .. border_group .. '#%*',
            '%#' .. group .. '#' .. pad(text) .. '%*',
            '%#' .. border_group .. '#%*',
          })
        else
          -- plano: quitar fondo usando grupo Flat
          local flat = ensure_flat_group(group)
          return '%#' .. flat .. '#' .. pad(text) .. '%*'
        end
      end

      local function custom_fileinfo()
        local ft  = vim.bo.filetype
        local enc = vim.bo.fileencoding or vim.bo.encoding
        if ft == '' then return '' end
        return ft .. '/' .. enc
      end

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

      local function git_status()
        local gs = vim.b.gitsigns_status_dict
        if not gs then return '' end
        local parts = {}
        if (gs.added or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitAdd',    '+' .. gs.added,    'GitBorderAdd'))
        end
        if (gs.changed or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitChange', '~' .. gs.changed,  'GitBorderChange'))
        end
        if (gs.removed or 0) > 0 then
          table.insert(parts, segment('MiniStatuslineGitRemove', '-' .. gs.removed,  'GitBorderRemove'))
        end
        return table.concat(parts, ' ')
      end

      -- Statusline ------------------------------------------------------------
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

            local current_mode = vim.api.nvim_get_mode().mode
            local mode_display, mode_hl =
              unpack(mode_map[current_mode] or { current_mode, 'MiniStatuslineModeNormal' })

            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end
            local location = '%2l:%-2v'
            local fileinfo = custom_fileinfo()
            local git      = git_status()
            local branch   = get_git_branch()

            -- Lado derecho: git + "segmentos" condicionales
            local right_parts = {}
            if git ~= '' then table.insert(right_parts, git) end

            local pills = {}
            if branch ~= '' then
              table.insert(pills, segment('MiniStatuslineBranch',   ' ' .. branch, 'MiniStatuslineBranchBorder'))
            end
            table.insert(pills, segment('MiniStatuslineFileinfo',   fileinfo,        'MiniStatuslineFileinfoBorder'))
            table.insert(pills, segment('MiniStatuslineLocation',   location,        'MiniStatuslineLocationBorder'))

            table.insert(right_parts, table.concat(pills, ' '))
            local right_section = table.concat(right_parts, '  ') -- 2 espacios tras git

            return statusline.combine_groups {
              { strings = { segment(mode_hl, mode_display, 'MiniStatuslineModeBorder') } },
              { strings = { segment('MiniStatuslineFilename', filename, 'MiniStatuslineFilenameBorder') } },
              '', -- respiro
              '%=',
              { strings = { right_section } },
            }
          end,

          inactive = function()
            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end
            local fileinfo = custom_fileinfo()
            return statusline.combine_groups {
              { strings = {
                  -- En transparente, fuerza plano para evitar “orejas”.
                  segment('MiniStatuslineInactiveFilename', filename,
                          'MiniStatuslineInactiveFilenameBorder',
                          { force_flat = vim.g.ashen_transparent })
                }
              },
              '%=',
              { strings = {
                  segment('MiniStatuslineInactiveFileinfo', fileinfo,
                          'MiniStatuslineInactiveFileinfoBorder',
                          { force_flat = vim.g.ashen_transparent })
                }
              },
            }
          end,
        },
      }
    end,
  },
}
