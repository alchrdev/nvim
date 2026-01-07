return {
  {
    "alchrdev/astereon.nvim",
    -- dir = "~/personal/code/astereon.nvim/",
    name = "astereon.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
      ids = {
       format = "%Y%m%d%H%M",
      },
      set_default_keymaps = true,
      open_new_note = false,
      new_note = {
        lowercase_filename = false,
      },

      ignore_dirs = { ".git", ".obsidian", "node_modules", "daily" },

      new_note_template = function(title, slug, id)
        return string.format([=[---
title: %q
id: %q
aliases:
  - 
categories: "[[../]]"
status: "[[draft]]"
tags:
  - 
---

# %s

]=], title, id, slug, title)
      end,

      snacks = {
        enable = true,
        preset = "vscode",
        show_index_numbers = false,
      },

      auto_refresh = {
        enable = true,
      },

      daily = {

        enable = true,
        folder = "daily",
        template = function(date, heading)
          local y, m, d = date:match("^(%d+)%-(%d+)%-(%d+)$")

          local now = os.time()
          local hh = tonumber(os.date("%H", now)) or 0
          local mi = tonumber(os.date("%M", now)) or 0

          local ts = now
          if y and m and d then
            ts = os.time({
              year = tonumber(y),
              month = tonumber(m),
              day = tonumber(d),
              hour = hh,
              min = mi,
              sec = 0,
            })
          end

          local fmt = (require("astereon").config.ids and require("astereon").config.ids.format) or "%Y%m%d%H%M"
          local id = os.date(fmt, ts)

          return table.concat({
            "---",
            ('id: "%s"'):format(id),
            "weather:",
            "bed_time:",
            "get_up:",
            "tags:",
            "  - notes",
            "  - journal",
            "---",
            "",
          }, "\n")
        end,
      },
    },
  },
}
