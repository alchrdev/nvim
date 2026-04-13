vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.surround').setup({
    custom_surroundings = {
        [')'] = { output = { left = '(', right = ')' } },
        [']'] = { output = { left = '[', right = ']' } },
    },
})

require('mini.pairs').setup()
require('mini.move').setup()
require('mini.indentscope').setup()
require('mini.bracketed').setup()

-- Statusline
local statusline = require('mini.statusline')

local function segment(group, text)
    text = tostring(text or '')
    if text == '' then return '' end
    return '%#' .. group .. '# ' .. text .. ' %*'
end

local function fileinfo()
    local ft  = vim.bo.filetype
    local enc = vim.bo.fileencoding or vim.bo.encoding
    if ft == '' then return '' end
    return ft .. '/' .. enc
end

statusline.setup({
    content = {
        active = function()
            local mode_map = {
                ['n']   = { 'N',  'MiniStatuslineModeNormal'  },
                ['no']  = { 'N',  'MiniStatuslineModeNormal'  },
                ['v']   = { 'V',  'MiniStatuslineModeVisual'  },
                ['V']   = { 'VL', 'MiniStatuslineModeVisual'  },
                ['\22'] = { 'VB', 'MiniStatuslineModeVisual'  },
                ['i']   = { 'I',  'MiniStatuslineModeInsert'  },
                ['ic']  = { 'I',  'MiniStatuslineModeInsert'  },
                ['R']   = { 'R',  'MiniStatuslineModeReplace' },
                ['c']   = { 'C',  'MiniStatuslineModeCommand' },
                ['t']   = { 'T',  'MiniStatuslineModeNormal'  },
            }

            local mode = vim.api.nvim_get_mode().mode
            local mode_display, mode_hl =
                unpack(mode_map[mode] or { mode, 'MiniStatuslineModeNormal' })

            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end

            return statusline.combine_groups({
                { strings = { segment(mode_hl, mode_display) } },
                { strings = { segment('MiniStatuslineFilename', filename) } },
                '%=',
                { strings = { segment('MiniStatuslineFileinfo', fileinfo()) } },
                { strings = { segment('MiniStatuslineLocation', '%2l:%-2v') } },
            })
        end,

        inactive = function()
            local filename = vim.fn.expand('%:~:.')
            if filename == '' then filename = '[No Name]' end
            return statusline.combine_groups({
                { strings = { segment('MiniStatuslineInactiveFilename', filename) } },
                '%=',
                { strings = { segment('MiniStatuslineInactiveFileinfo', fileinfo()) } },
            })
        end,
    },
})
