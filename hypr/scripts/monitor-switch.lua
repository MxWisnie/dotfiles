#!/usr/bin/env lua
-- monitor-switch.lua — Hyprland monitor profile switcher
-- ~/.config/hypr/scripts/monitor-switch.lua
-- Keybind: bind = $mainMod, F7, exec, bash -c 'lua ~/.config/hypr/scripts/monitor-switch.lua'

-- ── helpers ──────────────────────────────────────────────────────────────────

local function hyprctl(cmd)
  os.execute("hyprctl keyword monitor " .. cmd)
end

local function notify(msg)
  os.execute('notify-send "Monitor" "' .. msg .. '" --expire-time=2000')
end

-- ── terminal detection ────────────────────────────────────────────────────────
-- Resolve ~ so the path works when relaunching from alacritty

local home   = os.getenv("HOME")
local script = arg[0]:gsub("^~", home)  -- expand ~ if present

local tty    = io.popen("tty 2>/dev/null")
local tty_r  = tty:read("*l")
tty:close()

local in_terminal = tty_r and not tty_r:match("not a tty")

if not in_terminal then
  os.execute(
    "alacritty"
    .. " --class monitor-switch"
    .. " --option 'window.dimensions.columns=42'"
    .. " --option 'window.dimensions.lines=10'"
    .. " -e lua " .. script
  )
  os.exit(0)
end

-- ── menu ──────────────────────────────────────────────────────────────────────

print("")
print("  Monitor Profile")
print("  ───────────────")
print("  1) Laptop Only")
print("  2) External Only   (home)")
print("  3) Mirror Displays (school)")
print("  q) Cancel")
print("")
io.write("  Choice: ")
io.flush()

local choice = io.read("*l")

if choice == "1" then
  hyprctl('"eDP-1,preferred,auto,1"')
  hyprctl('"HDMI-A-1,disabled"')
  notify("Laptop only")

elseif choice == "2" then
  hyprctl('"HDMI-A-1,preferred,auto,auto"')
  hyprctl('"eDP-1,disabled"')
  notify("External only")

elseif choice == "3" then
  hyprctl('"eDP-1,preferred,0x0,1"')
  hyprctl('"HDMI-A-1,preferred,0x0,1,mirror,eDP-1"')
  notify("Mirroring displays")

else
  os.exit(0)
end
