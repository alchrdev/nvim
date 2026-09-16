vim.pack.add({ 'https://github.com/alchrdev/astereon.nvim' })

local blueprints = {
  default = function(title, slug, id)
    return string.format(
      [=[---
id: %q
title: %q
---

# %s

]=],
      id,
      title,
      title
    )
  end,
  vivre = {
    auto_title = true,
    template = function(title, slug, id)
      local y, m, d = title:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
      local ts = os.time()

      if y and m and d then
        ts = os.time({
          year = tonumber(y),
          month = tonumber(m),
          day = tonumber(d),
          hour = tonumber(os.date('%H')),
          min = tonumber(os.date('%M')),
          sec = 0,
        })
      end

      -- Utilizando el formateador nativo en español para evitar problemas de locales en Termux
      local sd = require('astereon').spanish_date(ts)
      local full_date = string.format("%s, %02d de %s del año %s a las %02d:%s %s",
        sd.day_name, sd.day, sd.month_name, sd.year, sd.hour12, sd.minute, sd.am_pm)
      local time_now = string.format("%02d:%s", sd.hour24, sd.minute)

      return string.format(
        [=[---
id: %q
weather:
bed_time:
get_up:
tags: [vivre]
---

# %s

## 🧭 DIRECTION

- [ ]

## ♥️ SILENT

- **::adventures::**
    - **%s** -

---
### 🏴‍☠️ TO BE CONTINUED

- [ ]
]=],
        id,
        full_date,
        time_now
      )
    end,
  },
  ohara = function(title, slug, id)
    return string.format(
      [=[---
id: %q
title: %q
url: ""
description: ""
categories:
status: active
tags:
cover: "[[.png]]"
---

# %s

]=],
      id,
      title,
      title
    )
  end,
  log_pose = function(title, slug, id)
    return string.format(
      [=[---
title: %q
id: %q
aliases: []
categories: "../"
status: "draft"
tags: []
---

# %s

]=],
      title,
      id,
      title
    )
  end,
  thousand_sunny = function(title, slug, id)
    return string.format(
      [=[---
id: %q
title: %q
tags:
cover: "[[]]"
---

]=],
      id,
      title
    )
  end,
}

require('astereon').setup({
  daily = {
    enable = true,
    folder = '10_vivre',
    template = function(date, heading)
      local id = os.date('%Y%m%d%H%M')
      return blueprints.vivre.template(date, date, id)
    end,
  },
  rename = {
    update_link_text = 'title',
    auto_prefers = 'title',
  },
  ids = {
    format = '%Y%m%d%H%M',
  },
  set_default_keymaps = true,
  open_new_note = false,
  new_note = {
    lowercase_filename = false,
  },
  media = {
    paste_folder = '99_cameko',
  },
  ignore_dirs = { '.obsidian', 'node_modules', '50_galley' },
  new_note_preferred_dirs = { '10_vivre', '20_nagi' },
  templates = blueprints,
  auto_refresh = {
    enable = true,
  },
})
