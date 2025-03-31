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
                # Git
                deadnix
                nixfmt-rfc-style
                pre-commit
                statix

                # LSP
                lua-language-server
                nixd
              ];
            };
          };
          packages = rec {
            default = thornevim;
            # Default
            thornevim = pkgs.callPackage ./pkgs/nvf-config.nix { inherit inputs; };
            transparent = thornevim.override {
              transparent = true;
            };
            # Maxi
            maxi = thornevim.override { maxi = true; };
            maxi-transparent = thornevim.override {
              transparent = true;
              maxi = true;
            };
            # Kanagawa
            kanagawa = thornevim.override {
              colorscheme = "kanagawa";
              variant = "dragon";
            };
            kanagawa-maxi = thornevim.override {
              colorscheme = "kanagawa";
              variant = "dragon";
              maxi = true;
            };
            kanagawa-maxi-transparent = thornevim.override {
              colorscheme = "kanagawa";
              transparent = true;
              variant = "dragon";
              maxi = true;
            };
            kanagawa-transparent = thornevim.override {
              colorscheme = "kanagawa";
              variant = "dragon";
              transparent = true;
            };
            # Oxocarbon
            oxocarbon = thornevim.override {
              colorscheme = "oxocarbon";
              variant = "dark";
            };
            oxocarbon-maxi = thornevim.override {
              colorscheme = "oxocarbon";
              variant = "dark";
              maxi = true;
            };
            oxocarbon-maxi-transparent = thornevim.override {
              colorscheme = "oxocarbon";
              transparent = true;
              variant = "dark";
              maxi = true;
            };
            oxocarbon-transparent = thornevim.override {
              colorscheme = "oxocarbon";
              variant = "dark";
              transparent = true;
            };
            # ThorneOS
            thorneos = thornevim.override { dots = "/persist/home/elias-ainsworth/projects/dotfiles"; };
            thorneos-kanagawa = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
              variant = "dragon";
            };
            thorneos-kanagawa-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              maxi = true;
              variant = "dragon";
              colorscheme = "kanagawa";
            };
            thorneos-kanagawa-maxi-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
              transparent = true;
              variant = "dragon";
              maxi = true;
            };
            thorneos-kanagawa-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "kanagawa";
              variant = "dragon";
              transparent = true;
            };
            thorneos-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              maxi = true;
            };
            thorneos-maxi-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              transparent = true;
              maxi = true;
            };
            thorneos-oxocarbon = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "oxocarbon";
              variant = "dark";
            };
            thorneos-oxocarbon-maxi = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              colorscheme = "oxocarbon";
              variant = "dark";
              maxi = true;
            };
            thorneos-transparent = thornevim.override {
              dots = "/persist/home/elias-ainsworth/projects/dotfiles";
              transparent = true;
            };
          };
        };
    };
}
