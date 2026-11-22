-- ─────────────────────────────────────────────
--  SMLinux · Hyprland configuration (Lua, Hyprland 0.57+)
--  Palette: ink #0E1420 · tangerine #FF7A3D · marigold #FFB347
--           coral #FF5E5B · mint #3DDBA8 · aqua #5EE6D0
--  Docs: https://wiki.hypr.land/configuring/
-- ─────────────────────────────────────────────

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- ── Programs ──
local terminal = "kitty"
local files    = "thunar"
local browser  = "firefox"
local menu     = "wofi --show drun"

-- ── Environment ──
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- ── Autostart ──
hl.on("hyprland.start", function()
    hl.exec_cmd("smlinux-wallpaper")            -- live wallpaper (falls back to the still SVG)
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("sleep 2 && notify-send -i smlinux 'Welcome to SMLinux' 'Super+Space opens apps · Super+Enter opens a terminal'")
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
        active_opacity   = 0.97,
        inactive_opacity = 0.90,

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

    -- Helps in VirtualBox / QEMU where hardware cursors are often invisible.
    cursor = { no_hardware_cursors = true },

    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
        },
    },
})

-- ── Animations: "liquid" curves ──
hl.curve("liquid", { type = "bezier", points = { {0.22, 1.00}, {0.36, 1.00} } })
hl.curve("glide",  { type = "bezier", points = { {0.05, 0.90}, {0.10, 1.05} } })
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

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Space",  hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(files))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + I",      hl.dsp.exec_cmd("smlinux-settings"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("smlinux-power"))
hl.bind(mod .. " + K",      hl.dsp.exec_cmd("smlinux-switch-desktop plasma"))
hl.bind(mod .. " + W",      hl.dsp.exec_cmd("smlinux-wallpaper toggle"))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mod .. " + J",      hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exit())

hl.bind("Print",         hl.dsp.exec_cmd("smlinux-screenshot area"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("smlinux-screenshot full"))

-- Focus / move windows
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. dir,           hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + SHIFT + " .. dir,   hl.dsp.window.move({ direction = dir }))
end

-- Workspaces 1-6
for i = 1, 6 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 5%+"),                            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"),                            { locked = true, repeating = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                                 { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                             { locked = true })

-- ── Rules ──
-- Frosted-glass blur behind the bar, dock, launcher and notifications
for _, ns in ipairs({ "waybar", "wofi", "notifications" }) do
    hl.layer_rule({ name = "glass-" .. ns, match = { namespace = "^" .. ns .. "$" }, blur = true, ignore_alpha = 0 })
end

-- Small utility windows float, centred
hl.window_rule({
    name  = "float-utilities",
    match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|nm-connection-editor|blueman-manager)$" },
    float = true,
    center = true,
    size  = "900 600",
})

hl.window_rule({
    name   = "float-dialogs",
    match  = { class = "^(org.kde.kdialog|kdialog)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
