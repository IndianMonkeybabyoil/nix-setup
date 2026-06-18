#!/usr/bin/env bash
set -e

echo "=== 1. Creating Configuration Directories ==="
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/ghostty ~/projects

echo "=== 2. Writing Hyprland Configuration ==="
cat << 'EOF' > ~/.config/hypr/hyprland.conf
# ==============================================================================
# HYPRLAND CONFIGURATION
# ==============================================================================

# 1. Monitors
monitor=,preferred,auto,1

# 2. Startup Programs
exec-once = waybar                             # Top status bar
exec-once = swww init                          # Wallpaper daemon
exec-once = dunst                              # Notification manager
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# 3. Input & Keyboard
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = no
    }
    sensitivity = 0
}

# 4. Gaps, Borders, and Themes
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
        new_optimizations = true
    }
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# 5. Animations
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popup 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# 6. Layouts
dwindle {
    pseudotile = yes
    preserve_split = yes
}

# 7. Window Rules
windowrulev2 = float,class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = float,title:^(Media viewer)$
windowrulev2 = float,title:^(Volume Control)$

# 8. Keybindings
$mainMod = SUPER

bind = $mainMod, Q, exec, ghostty              # Open Ghostty Terminal
bind = $mainMod, R, exec, rofi -show drun       # Open App Launcher
bind = $mainMod, C, killactive,                 # Close active window
bind = $mainMod, M, exit,                       # Log out of Hyprland
bind = $mainMod, E, exec, dolphin               # File Manager
bind = $mainMod, V, togglefloating,             # Toggle Window Floating
bind = $mainMod, P, pseudo,                     # dwindle layout toggle
bind = $mainMod, J, togglesplit,                # dwindle layout split type

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Workspace scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# 9. Hardware Keys
binde = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
EOF

echo "=== 3. Writing Waybar Layout (JSON) ==="
cat << 'EOF' > ~/.config/waybar/config
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["cpu", "memory", "network", "battery"],
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}"
    }
}
EOF

echo "=== 4. Writing Waybar Styling (CSS) ==="
cat << 'EOF' > ~/.config/waybar/style.css
window#waybar {
    background: rgba(30, 30, 46, 0.85); /* Dark Catppuccin color with blur */
    border-bottom: 2px solid #cdd6f4;
    color: #cdd6f4;
    font-family: "JetBrainsMono Nerd Font", sans-serif;
    font-size: 14px;
}

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: #89b4fa;
}

#workspaces button.active {
    color: #a6e3a1;
    border-bottom: 3px solid #a6e3a1;
}

#clock, #cpu, #memory, #network, #battery {
    padding: 0 10px;
    margin: 0 5px;
}
EOF

echo "=== 5. Writing Ghostty Configuration ==="
cat << 'EOF' > ~/.config/ghostty/config
theme = catppuccin-mocha
background-opacity = 0.85
background-blur = true
window-decoration = false
window-padding-x = 12
window-padding-y = 12

font-family = "JetBrainsMono Nerd Font"
font-size = 11.5
font-style = Regular
font-style-bold = Bold
antialias = true
font-features = liga

cursor-style = block
cursor-style-blink = true
cursor-color = #f5c2e7

rendering-backend = metal-or-opengl
copy-on-select = true

keybind = ctrl+shift+equal = increase_font_size
keybind = ctrl+shift+minus = decrease_font_size
keybind = ctrl+shift+zero = reset_font_size
keybind = ctrl+shift+c = copy_to_clipboard
keybind = ctrl+shift+v = paste_from_clipboard
EOF

echo "=== 6. Setting up Development Workspace ==="
cd ~/projects/

cat << 'EOF' > shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    binutils
    rustc
    cargo
    zig
    uv
    shellcheck
    pkg-config
    openssl
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    stdenv.cc.cc.lib
    openssl
  ]);
}
EOF

echo "use nix" > .envrc

# Ensure direnv checks are met if installed
if command -v direnv &> /dev/null; then
    direnv allow
fi

echo "=== Environment Configuration Finished! ==="