{
  description = "HyprSwipe - A 3x3 workspace grid plugin for Hyprland";

  inputs = {
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, hyprland, nixpkgs }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          hyprswipe = pkgs.stdenv.mkDerivation {
            pname = "hyprswipe";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              meson
              ninja
              pkg-config
              cmake
              hyprwayland-scanner
            ];

            buildInputs = [
              hyprland.packages.${system}.hyprland
              pkgs.aquamarine
              pkgs.hyprutils
              pkgs.hyprlang
              pkgs.hyprcursor
              pkgs.hyprgraphics
              pkgs.pixman
              pkgs.libxkbcommon
              pkgs.libdrm
              pkgs.libinput
              pkgs.mesa
              pkgs.pango
              pkgs.cairo
              pkgs.libGL
              pkgs.wayland
              pkgs.wayland-protocols
              pkgs.xorg.libX11
              pkgs.xorg.libxcb
              pkgs.xorg.xcbutilwm
              pkgs.xorg.xcbutilrenderutil
              pkgs.xorg.xcbutilerrors
              pkgs.xorg.xcbutilkeysyms
              pkgs.xorg.xcbutilimage
            ];

            meta = with pkgs.lib; {
              description = "A 3x3 workspace grid plugin for Hyprland";
              homepage = "https://github.com/0cx96/hyprswipe";
              license = licenses.mit;
              platforms = platforms.linux;
              maintainers = [ ];
            };
          };

          default = self.packages.${system}.hyprswipe;
        });

      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "hyprswipe-dev";
            
            nativeBuildInputs = with pkgs; [
              meson
              ninja
              pkg-config
              gcc
              cmake
              hyprwayland-scanner
            ];

            buildInputs = [
              hyprland.packages.${system}.hyprland
              pkgs.aquamarine
              pkgs.hyprutils
              pkgs.hyprlang
              pkgs.hyprcursor
              pkgs.hyprgraphics
              pkgs.pixman
              pkgs.libxkbcommon
              pkgs.libdrm
              pkgs.libinput
              pkgs.mesa
              pkgs.pango
              pkgs.cairo
              pkgs.libGL
              pkgs.wayland
              pkgs.wayland-protocols
              pkgs.xorg.libX11
              pkgs.xorg.libxcb
              pkgs.xorg.xcbutilwm
              pkgs.xorg.xcbutilrenderutil
              pkgs.xorg.xcbutilerrors
              pkgs.xorg.xcbutilkeysyms
              pkgs.xorg.xcbutilimage
            ];

            shellHook = ''
              echo "HyprSwipe Development Shell"
              echo "Run: meson setup build && ninja -C build"
            '';
          };
        });
    };
}
