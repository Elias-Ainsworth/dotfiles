{
  description = "Elias Ainsworth's dotfiles managed via NixOS and home-manager, entirely based off of Grandmaster iynaix's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=918d8340afd652b011b937d29d5eea0be08467f5";

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thornevim = {
      url = "github:elias-ainsworth/thornevim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thornemacs = {
      url = "github:elias-ainsworth/thornemacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pilum-murialis = {
      url = "github:elias-ainsworth/pilum-murialis.xyz";
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

    nixcord = {
      url = "github:kaylorben/nixcord";
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

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      flake =
        let
          inherit (inputs.nixpkgs) lib;
          pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          user = "elias-ainsworth";
          hostNixosModule = import ./hosts/nixos.nix { inherit inputs self user; };
          inherit (hostNixosModule) mkNixos mkVm;
        in
        {
          nixosConfigurations = {
            desktop = mkNixos "desktop" { };
            framework = mkNixos "framework" { };
            x1c = mkNixos "x1c" { };
            x1c-8 = mkNixos "x1c-8" { };
            t440 = mkNixos "t440" { };
            t520 = mkNixos "t520" { };
            # VMs from config
            vm = mkVm "vm" { };
            # hyprland can be used within a VM on AMD
            vm-hyprland = mkVm "vm" {
              extraConfig = {
                home-manager.users.${user}.custom.wm = lib.mkForce "hyprland";
              };
            };
            # create VMs for each host configuration, build using
            # nixos-rebuild build-vm --flake .#desktop-vm
            desktop-vm = mkVm "desktop" { isVm = true; };
            framework-vm = mkVm "framework" { isVm = true; };
            x1c-vm = mkVm "x1c" { isVm = true; };
            x1c-8-vm = mkVm "x1c-8" { isVm = true; };
            t440-vm = mkVm "t440" { isVm = true; };
            t520-vm = mkVm "t520" { isVm = true; };
          }
          // (import ./hosts/iso { inherit inputs self; });

          inherit lib;

          libCustom = import ./lib.nix { inherit lib pkgs user; };

          inherit self; # for repl debugging

          templates = import ./templates;
        };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = import ./shell.nix { inherit pkgs; };
          packages = (import ./packages) { inherit inputs pkgs; };
        };
    });
}
