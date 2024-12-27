local W = require('wezterm')
local Bind = require('binding')
local C = {}
local Menu = {}

-- Setup Shell
if W.target_triple == "x86_64-pc-windows-msvc" then
  local is_windows11 = false

  -- Grab the ver info for later use.
  local _, stdout, _ = W.run_child_process({ "cmd.exe", "ver" })
  local _, _, build, _ = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
  is_windows11 = tonumber(build) >= 22000

  -- Make it look cool.
  if is_windows11 then
    W.log_info("We're running Windows 11!")
  end

  -- Set Pwsh as the default on Windows
  C.default_prog = { "pwsh.exe", "-NoLogo" }
  table.insert(Menu, {
    label = "PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  })
  table.insert(Menu, {
    label = "CMD",
    args = { "cmd.exe" },
  })
else
  --- Non-Windows Machine
  C.default_prog = { "bash", "-NoLogo" }
  table.insert(Menu, {
    label = "Bash",
    args = { "/usr/bin/bash" },
  })
end

-- Appearance
local SCHEME_NAME = 'Nord (Gogh)'
local TB_BASE = '#252525'
local TB_HOVER = '#101010'
local WK_FONT = '#808080'
local BOLD = 'Bold'

C.window_decorations = 'RESIZE' -- disable the title bar but enable the resizable border
C.color_scheme = SCHEME_NAME
C.use_fancy_tab_bar = false
C.hide_tab_bar_if_only_one_tab = true

C.colors = {
  tab_bar = {
    background = TB_BASE,
    active_tab = {
      -- The color of the background area for the tab
      bg_color = W.color.get_builtin_schemes()[SCHEME_NAME].background,
      -- The color of the text for the tab
      fg_color = W.color.get_builtin_schemes()[SCHEME_NAME].foreground,
      -- "Half", "Normal" or "Bold", default is "Normal"
      intensity = BOLD,
      -- "None", "Single" or "Double", default is "None"
      underline = 'None',
      -- The default is false.
      italic = false,
      -- The default is false.
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = TB_BASE,
      fg_color = WK_FONT,
    },
    inactive_tab_hover = {
      bg_color = TB_HOVER,
      fg_color = WK_FONT,
      intensity = BOLD,
    },
    new_tab = {
      bg_color = TB_BASE,
      fg_color = WK_FONT,
    },
    new_tab_hover = {
      bg_color = TB_HOVER,
      fg_color = WK_FONT,
      intensity = BOLD,
    },
  },
}

C.window_background_opacity = 0.6
C.text_background_opacity = 0.65
C.default_cursor_style = 'BlinkingBlock'
C.font = W.font('FiraCode Nerd Font')
C.font_size = 12.5
C.adjust_window_size_when_changing_font_size = false
C.tab_max_width = 26

C.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

C.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- Set Contents
C.launch_menu = Menu
C.scrollback_lines = 7000

Bind.setup(C)

return C
