{
  description = "Elias Ainsworth's dotfiles managed via NixOS and home-manager, entirely based off of Grandmaster iynaix's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=918d8340afd652b011b937d29d5eea0be08467f5";

    # waiting for fix for https://github.com/NixOS/nixpkgs/issues/348819
    nixpkgs-cliphist.url = "github:NixOS/nixpkgs/5633bcff0c6162b9e4b5f1264264611e950c8ec7";

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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    tuido = {
      url = "gitlab:Oglo12/tuido";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jerry = {
      url = "github:justchokingaround/jerry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lobster = {
      url = "github:justchokingaround/lobster";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mamelon = {
      url = "github:elias-ainsworth/mamelon-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kollektif = {
      url = "github:elias-ainsworth/kollektif-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOTE: This will require your git SSH access to the repo.
    # disable ghostty by commenting out the following input and setting
    # the hm option config.custom.ghostty.enable = false
    #
    # WARNING: Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    # ghostty = {
    #   url = "git+ssh://git@github.com/mitchellh/ghostty";
    # };
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

      homeConfigurations = import ./hosts/hm.nix commonArgs;

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
