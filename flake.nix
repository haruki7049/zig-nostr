{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, lib, ... }:
        let
          zig_nostr = pkgs.stdenv.mkDerivation {
            name = "zig-nostr";
            src = lib.cleanSource ./.;

            nativeBuildInputs = [
              pkgs.zig_0_13.hook
            ];

            postInstall = ''
              zig build docs --prefix $out
            '';
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.zig.enable = true;
            programs.mdformat.enable = true;
            settings.excludes = [
              "LICENSE"
              ".gitignore"
              "flake.lock"
            ];
          };

          packages = {
            inherit zig_nostr;
            default = zig_nostr;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.zig_0_13
              pkgs.nil
            ];
          };
        };
    };
}
