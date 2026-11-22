# SMLinux: load .bashrc, then start the chosen desktop on the first console.
# The choice lives in ~/.config/smlinux/session ("hyprland" or "plasma");
# smlinux-switch-desktop changes it and logs out, and auto-login brings you back.
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
    session=$(cat ~/.config/smlinux/session 2>/dev/null || echo hyprland)
    started=$SECONDS

    case $session in
        plasma)
            if [[ -x /usr/lib/plasma-dbus-run-session-if-needed ]]; then
                /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland
            else
                dbus-run-session startplasma-wayland
            fi ;;
        *)
            if command -v start-hyprland >/dev/null 2>&1; then
                start-hyprland
            else
                Hyprland
            fi ;;
    esac

    # If the desktop died within 10 seconds it's probably broken - fall back to the other
    # one next time instead of looping forever.
    if (( SECONDS - started < 10 )); then
        mkdir -p ~/.config/smlinux
        [[ $session == plasma ]] && echo hyprland > ~/.config/smlinux/session \
                                 || echo plasma   > ~/.config/smlinux/session
        echo "The $session desktop failed to start - switching to the other desktop."
        sleep 4
    fi
    logout
fi
