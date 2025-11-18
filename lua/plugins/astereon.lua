return {
  {
    "alchrdev/astereon.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
      set_default_keymaps = true,
      open_new_note = false,
      display = {
        search_link        = "filename",
        folder_search_link = "label+path",
        open_pick          = "filename",
        open_folder_pick   = "label+path",
        snacks = {
          default = {
            preview = true,
            layout = {
              preset = "dropdown",
              preview = {
                enabled = false,
                width = 0.45,
              },
            },
          },
          open_pick = {
            preview = true,
            layout = {
              preset = "vscode",
              preview = { enabled = false },
            },
          },
        },
      },
      rename = { update_link_text = "filename" },
      media = {
        embed_images = true,
        prompt_alt_for_images = true,
        snacks = {
          preview = true,
          layout = {
            preset = "ivy",
            preview = {
              enabled = true,
              width = 0.45,
            },
          },
        },
      },
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
        folder = "apsn/dly",
      }
    },
  },
}
