{
  description = "Elias Ainsworth's dotfiles managed via NixOS and home-manager, entirely based off of Grandmaster iynaix's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=918d8340afd652b011b937d29d5eea0be08467f5";

    devenv.url = "github:cachix/devenv";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # helix = {
    #   url = "github:helix-editor/helix";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wfetch = {
      url = "github:iynaix/wfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    focal = {
      url = "github:iynaix/focal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jerry = {
      url = "github:justchokingaround/jerry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mamelon = {
      url = "github:elias-ainsworth/mamelon-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # flake-utils is unnecessary
  # https://ayats.org/blog/no-flake-utils/
  outputs =
    inputs@{ nixpkgs, self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = import ./lib.nix {
        inherit (nixpkgs) lib;
        inherit pkgs;
        inherit (inputs) home-manager;
      };
      createCommonArgs = system: {
        inherit
          self
          inputs
          nixpkgs
          lib
          pkgs
          system
          ;
        specialArgs = {
          inherit self inputs;
        };
      };
      commonArgs = createCommonArgs system;
      # call with forAllSystems (commonArgs: function body)
      forAllSystems =
        fn:
        lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: fn (createCommonArgs system));
    in
    {
      nixosConfigurations = (import ./hosts/nixos.nix commonArgs) // (import ./hosts/iso commonArgs);

      homeConfigurations = import ./hosts/home-manager.nix commonArgs;

      # devenv for working on dotfiles, provides rust environment
      devShells = forAllSystems (commonArgs': {
        default = import ./devenv.nix commonArgs';
      });

      inherit lib self;

      packages = forAllSystems (commonArgs': (import ./packages commonArgs'));

      # templates for devenvs
      templates = import ./templates;
    };
}
