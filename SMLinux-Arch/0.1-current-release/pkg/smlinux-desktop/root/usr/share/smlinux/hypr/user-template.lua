-- ~/.config/hypr/hyprland.lua - your personal Hyprland config.
--
-- SMLinux's defaults load first. They come from the smlinux-desktop package,
-- so improvements arrive with normal system updates (pacman -Syu).
-- Anything you add below this line overrides the defaults.
package.path = "/usr/share/smlinux/hypr/?.lua;" .. package.path
require("smlinux")

-- Examples (remove the leading -- to use them):
-- hl.config({ general = { gaps_out = 8 } })
-- hl.config({ input = { kb_layout = "de" } })
-- hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
