{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, gitignore }:
    let
      inherit (nixpkgs.lib) genAttrs;

      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllPkgs = function: forAllSystems (system: function pkgs.${system});

      pkgs = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ ];
      }));
    in
    {
      formatter = forAllPkgs (pkgs: pkgs.nixpkgs-fmt);

      packages = forAllPkgs (pkgs: rec {
        default = app;
        app = pkgs.callPackage ./package.nix { inherit gitignore; };
      });

      devShells = forAllPkgs (pkgs:
        with pkgs.lib;
        {
          default = pkgs.mkShell rec {
            nativeBuildInputs = with pkgs; [
              pkg-config

              meson
              ninja
            ];

            buildInputs = with pkgs; [
              cairo
              giflib
              libev
              libxkbcommon
              linux-pam
              xcbutilxrm
              xorg.libX11
              xorg.libxcb
              xorg.libxcb
              xorg.xcbutil
              xorg.xcbutilimage
            ];

            LD_LIBRARY_PATH = makeLibraryPath buildInputs;
          };
        });
    };
}
