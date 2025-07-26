{
  inputs,
  lib,
  specialArgs,
  user ? "elias-ainsworth",
  ...
}@args:
let
  # provide an optional { pkgs } 2nd argument to override the pkgs
  mkNixosConfiguration =
    host:
    {
      pkgs ? args.pkgs,
      isVm ? false,
      extraConfig ? { },
    }:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // {
        inherit host user isVm;
        isNixOS = true;
        isLaptop = host == "framework" || host == "x1c" || host == "t520"; # || host == "t440";
        dots = "/persist/home/${user}/projects/dotfiles";
      };

      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../nixos
        ../overlays
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              inherit host user isVm;
              isNixOS = true;
              isLaptop = host == "framework" || host == "x1c" || host == "t520"; # || host == "t440";
              dots = "/persist/home/${user}/projects/dotfiles";
            };

            users.${user} = {
              imports = [
                inputs.nix-index-database.homeModules.nix-index
                inputs.niri.homeModules.niri
                ./${host}/home.nix # host specific home-manager configuration
                ../home-manager
              ];
            };
          };
        }
        # alias for home-manager
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        extraConfig
      ];
    };
  mkVm =
    host: mkNixosConfigurationArgs:
    mkNixosConfiguration host (mkNixosConfigurationArgs // { isVm = true; });
in
{
  desktop = mkNixosConfiguration "desktop" { };
  framework = mkNixosConfiguration "framework" { };
  x1c = mkNixosConfiguration "x1c" { };
  t520 = mkNixosConfiguration "t520" { };
  t440 = mkNixosConfiguration "t440" { };
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
  t520-vm = mkVm "t520" { isVm = true; };
}
