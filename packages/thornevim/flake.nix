{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default-linux";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        { pkgs, ... }:
        {
          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                nixd
                nixfmt-rfc-style
                deadnix
                statix
                pre-commit
                lua-language-server
              ];
            };
          };
          packages = rec {
            thornevim = pkgs.callPackage ./pkgs/nvf-config.nix { inherit inputs; };
            default = thornevim;
            maxi = thornevim.override { maxi = true; };
            oxocarbon = thornevim.override { colorscheme = "oxocarbon"; };
            kanagawa = thornevim.override { colorscheme = "kanagawa"; };
            kanagawa-transparent = thornevim.override {
              colorscheme = "kanagawa";
              transparency = true;
            };
            transparent = thornevim.override {
              transparency = true;
            };
            thorneos = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
            };
            thorneos-kanagawa = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
            };
            thorneos-oxocarbon = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "oxocarbon";
            };
            thorneos-kanagawa-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
              transparency = true;
            };
            thorneos-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              transparency = true;
            };
            oxocarbon-maxi = thornevim.override {
              colorscheme = "oxocarbon";
              maxi = true;
            };
            kanagawa-maxi = thornevim.override {
              colorscheme = "kanagawa";
              maxi = true;
            };
            kanagawa-transparent-maxi = thornevim.override {
              colorscheme = "kanagawa";
              transparency = true;
              maxi = true;
            };
            transparent-maxi = thornevim.override {
              transparency = true;
              maxi = true;
            };
            thorneos-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              maxi = true;
            };
            thorneos-kanagawa-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              maxi = true;
              colorscheme = "kanagawa";
            };
            thorneos-oxocarbon-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "oxocarbon";
              maxi = true;
            };
            thorneos-kanagawa-transparent-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
              transparency = true;
              maxi = true;
            };
            thorneos-transparent-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              transparency = true;
              maxi = true;
            };
          };
        };
    };
}
