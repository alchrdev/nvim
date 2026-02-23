return {
  {
    "alchrdev/astereon.nvim",
    -- dir = "~/personal/code/astereon.nvim/",
    name = "astereon.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
      rename = {
        update_link_text = "title",
        update_yaml_title = true,
      },
      ids = {
       format = "%Y%m%d%H%M",
      },
      set_default_keymaps = true,
      open_new_note = false,
      new_note = {
        lowercase_filename = false,
      },

      ignore_dirs = { ".git", ".obsidian", "node_modules", "90_vivre" },

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
        folder = "90_vivre",
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
          -- Formato: dddd, D de MMMM del año YYYY a las h:mm A
          local full_date = os.date("%A, %d de %B del año %Y a las %I:%M %p", ts)
          local time_now = os.date("%H:%M", ts)

          return table.concat({
            "---",
            ('id: "%s"'):format(id),
            "weather: ",
            "bed_time: ",
            "get_up: ",
            "tags: [vivre]",
            "---",
            "",
            ("# %s"):format(full_date),
            "",
            "## 🧭 DIRECTION",
            "",
            "- [ ] ",
            "",
            "## ♥️ SILENT",
            "",
            "- **::adventures::**",
            ("    - **%s** - "):format(time_now),
            "",
            "---",
            "### 🏴‍☠️ TO BE CONTINUED",
            "",
            "- [ ] ",
          }, "\n")
        end,
      },
    },
  },
}
