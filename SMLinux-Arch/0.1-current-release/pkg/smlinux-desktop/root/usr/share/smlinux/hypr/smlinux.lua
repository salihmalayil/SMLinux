-- ─────────────────────────────────────────────
--  SMLinux · Hyprland defaults (Lua, Hyprland 0.57+)
--  Owned by the smlinux-desktop package: fixes arrive with `pacman -Syu`.
--  Don't edit this file. Your own changes go in ~/.config/hypr/hyprland.lua,
--  which loads this file first.
--
--  Palette: ink #0E1420 · tangerine #FF7A3D · marigold #FFB347
--           coral #FF5E5B · mint #3DDBA8 · aqua #5EE6D0
--  Docs: https://wiki.hypr.land/configuring/
-- ─────────────────────────────────────────────

local HOME = os.getenv("HOME") or ""
local LIVE = os.getenv("SMLINUX_LIVE") == "1"    -- set by smlinux-session
local VM   = os.getenv("SMLINUX_VM") == "1"

local function exists(path)
    local f = io.open(path, "r")
    if f then f:close() return true end
    return false
end
-- use the user's own config file for a tool if they have one
local function user_has(rel) return exists(HOME .. "/.config/" .. rel) end

-- ── Monitors: native resolution, scale picked from the screen's size/DPI ──
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- ── Programs ──
local terminal = "kitty"
local files    = "thunar"
local browser  = "firefox"
local menu     = "smlinux-menu --show drun"

-- ── Environment ──
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")            -- Qt apps follow the dark KDE theme here too
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- ── Live wallpaper pausing: fullscreen apps and battery power ──
local function find_ac_supply()
    local p = io.popen("ls /sys/class/power_supply 2>/dev/null")
    if not p then return nil end
    local found
    for name in p:lines() do
        local t = io.open("/sys/class/power_supply/" .. name .. "/type", "r")
        if t then
            if t:read("*l") == "Mains" then found = "/sys/class/power_supply/" .. name .. "/online" end
            t:close()
        end
    end
    p:close()
    return found
end

local function start_wallpaper_pauser()
    local ac = find_ac_supply()             -- nil on desktops without a battery/charger
    local flag = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/smlinux-wallpaper-paused"
    local last
    hl.timer(function()
        local paused = false
        local w = hl.get_active_window()
        if w and w.fullscreen and w.fullscreen > 0 then paused = true end
        if ac then
            local f = io.open(ac, "r")
            if f then
                if f:read("*l") == "0" then paused = true end
                f:close()
            end
        end
        if paused ~= last then
            local f = io.open(flag, "w")
            if f then f:write(paused and "1" or "0") f:close() end
            last = paused
        end
    end, { timeout = 3000, type = "repeat" })
end

-- ── Autostart ──
hl.on("hyprland.start", function()
    -- portals and systemd user services need the session environment
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE QT_QPA_PLATFORMTHEME")
    hl.exec_cmd("smlinux-wallpaper")
    hl.exec_cmd("smlinux-bar")
    hl.exec_cmd(user_has("mako/config") and "mako" or "mako --config /usr/share/smlinux/mako/config")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    if not LIVE then
        -- lock after 5 min, screen off after 10, suspend after 30 (not on the live USB)
        hl.exec_cmd(user_has("hypr/hypridle.conf") and "hypridle" or "hypridle -c /usr/share/smlinux/hypr/hypridle.conf")
    end
    start_wallpaper_pauser()

    if LIVE then
        hl.exec_cmd("sleep 2 && notify-send -t 15000 -i smlinux 'Welcome to SMLinux (live)' "
            .. "'Super+Space opens apps · Super+Enter opens a terminal · password: smlinux\\n"
            .. "Install with the download button in the dock.'")
    else
        hl.exec_cmd("sleep 2 && notify-send -i smlinux 'Welcome to SMLinux' 'Super+Space opens apps · Super+Enter opens a terminal'")
    end
end)

-- ── Look ──
hl.config({
    general = {
        gaps_in          = 6,
        gaps_out         = 14,
        border_size      = 2,
        resize_on_border = true,
        layout           = "dwindle",
        col = {
            active_border   = { colors = { "rgba(ff7a3dee)", "rgba(ffb347ee)", "rgba(3ddba8ee)" }, angle = 45 },
            inactive_border = "rgba(ffffff1a)",
        },
    },

    decoration = {
        rounding         = 16,
        rounding_power   = 2,
        -- windows stay fully opaque: readable text and true video colours
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        dim_inactive     = false,

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
            vibrancy          = 0.25,
            noise             = 0.015,
            popups            = true,
        },

        shadow = {
            enabled      = true,
            range        = 24,
            render_power = 3,
            color        = "rgba(05080fcc)",
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        background_color         = "rgb(0e1420)",
    },

    -- Software cursors only in virtual machines (where hardware cursors are often invisible)
    cursor = { no_hardware_cursors = VM },

    input = {
        kb_layout    = os.getenv("SMLINUX_KB_LAYOUT") or "us",   -- from the layout chosen at install
        kb_variant   = os.getenv("SMLINUX_KB_VARIANT") or "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
        },
    },
})

-- 3-finger swipe left/right changes workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ── Animations: "liquid" curves ──
hl.curve("liquid", { type = "bezier", points = { {0.22, 1.00}, {0.36, 1.00} } })
hl.curve("soft",   { type = "bezier", points = { {0.40, 0.00}, {0.20, 1.00} } })
hl.curve("flow",   { type = "spring", mass = 1, stiffness = 210, damping = 22 })

hl.animation({ leaf = "global",      enabled = true, speed = 8,  bezier = "soft" })
hl.animation({ leaf = "windows",     enabled = true, speed = 5,  spring = "flow" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5,  spring = "flow", style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4,  bezier = "soft", style = "popin 85%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "soft" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 60, bezier = "soft", style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 6,  bezier = "soft" })
hl.animation({ leaf = "layers",      enabled = true, speed = 5,  bezier = "liquid", style = "slide" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "liquid", style = "slidefade 15%" })

-- ── Keybinds ──
local mod = "SUPER"

hl.bind(mod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Space",     hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + E",         hl.dsp.exec_cmd(files))
hl.bind(mod .. " + B",         hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + I",         hl.dsp.exec_cmd("smlinux-settings"))
hl.bind(mod .. " + Escape",    hl.dsp.exec_cmd("smlinux-power"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("smlinux-power"))   -- same menu: asks before logging out
hl.bind(mod .. " + K",         hl.dsp.exec_cmd("smlinux-switch-desktop plasma"))
hl.bind(mod .. " + W",         hl.dsp.exec_cmd("smlinux-wallpaper toggle"))
hl.bind(mod .. " + D",         hl.dsp.exec_cmd("smlinux-bar toggle-dock"))
hl.bind(mod .. " + N",         hl.dsp.exec_cmd("smlinux-dnd"))
hl.bind(mod .. " + C",         hl.dsp.exec_cmd("smlinux-clipboard"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(mod .. " + L",         hl.dsp.exec_cmd("smlinux-lock"))
hl.bind(mod .. " + Q",         hl.dsp.window.close())
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mod .. " + J",         hl.dsp.layout("togglesplit"))

hl.bind("Print",         hl.dsp.exec_cmd("smlinux-screenshot area"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("smlinux-screenshot full"))

-- Focus / move windows
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. dir,         hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

-- Workspaces 1-6 (the bar shows the same six)
for i = 1, 6 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys, with on-screen pop-ups (swayosd)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          { locked = true, repeating = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- ── Rules ──
-- Frosted-glass blur behind the bar, dock, launcher, notifications and pop-ups
for _, ns in ipairs({ "waybar", "wofi", "notifications", "swayosd" }) do
    hl.layer_rule({ name = "glass-" .. ns, match = { namespace = "^" .. ns .. "$" }, blur = true, ignore_alpha = 0 })
end

-- Only these windows float in the centre; other pop-ups keep their own position
hl.window_rule({
    name   = "float-sized-utilities",
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|blueman-manager)$" },
    float  = true,
    center = true,
    size   = "900 600",
})
hl.window_rule({
    name   = "float-small-utilities",
    match  = { class = "^(nm-connection-editor|org.kde.kdialog|kdialog)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    name   = "float-smlinux-tools",          -- Wi-Fi picker, config editor
    match  = { class = "^(smlinux-float)$" },
    float  = true,
    center = true,
    size   = "780 540",
})
hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
