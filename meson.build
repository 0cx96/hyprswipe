project('hyprswipe', 'cpp',
  version: '0.1.0',
  default_options: ['cpp_std=c++23', 'buildtype=release'])

cpp_compiler = meson.get_compiler('cpp')

# Find Hyprland using pkg-config
dep_hyprland = dependency('hyprland')

# Add necessary include directories
# Note: Hyprland headers are usually in /usr/include/hyprland or provided by the flake
# The 'hyprland' dependency from pkg-config should handle this.

shared_module('hyprswipe',
  'src/main.cpp',
  dependencies: [
    dep_hyprland,
  ],
  install: true,
)
