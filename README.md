# HyprSwipe

A Hyprland plugin that implements a 3x3 workspace grid with gesture navigation.

## Features

- **3x3 Workspace Grid**: Navigate workspaces in a 2D grid (named `1-1` through `3-3`)
- **Gesture Support**: 3-finger swipe gestures for navigation
- **Special Workspace Toggle**: Diagonal swipe to toggle special workspace
- **Starting Position**: Automatically starts at center workspace (`2-2`)

## Installation

### 1. Add to your flake inputs

```nix
{
  inputs = {
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    
    hyprswipe = {
      url = "github:yourusername/hyprswipe";
      inputs.hyprland.follows = "hyprland";
    };
  };
}
```

### 2. Add to your Home Manager configuration

```nix
{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    
    plugins = [
      inputs.hyprswipe.packages.${pkgs.stdenv.hostPlatform.system}.hyprswipe
    ];
    
    settings = {
      # ... your other settings ...
    };
    
    extraConfig = ''
      # HyprSwipe gesture bindings
      bind = , swipe:3:r, hyprswipe:right
      bind = , swipe:3:l, hyprswipe:left
      bind = , swipe:3:u, hyprswipe:up
      bind = , swipe:3:d, hyprswipe:down
      
      # Optional: keyboard bindings for testing
      bind = SUPER, H, hyprswipe:left
      bind = SUPER, L, hyprswipe:right
      bind = SUPER, K, hyprswipe:up
      bind = SUPER, J, hyprswipe:down
      bind = SUPER, Space, hyprswipe:diagonal
    '';
  };
}
```

## Workspace Grid Layout

```
┌─────┬─────┬─────┐
│ 1-1 │ 1-2 │ 1-3 │
├─────┼─────┼─────┤
│ 2-1 │ 2-2 │ 2-3 │  ← Starts here
├─────┼─────┼─────┤
│ 3-1 │ 3-2 │ 3-3 │
└─────┴─────┴─────┘

Special Workspace: 0 (toggle with diagonal swipe)
```

## Dispatchers

- `hyprswipe:right` - Move to next column (east)
- `hyprswipe:left` - Move to previous column (west)
- `hyprswipe:up` - Move to previous row (north)
- `hyprswipe:down` - Move to next row (south)
- `hyprswipe:diagonal` - Toggle special workspace

## Building from Source

```bash
nix develop
meson setup build
ninja -C build
```

The plugin will be at `build/libhyprswipe.so`.

## License

MIT
