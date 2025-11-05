{
  flake.nixosModules.gaming =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        inputs.nix-gaming.nixosModules.platformOptimizations
      ];

      environment.systemPackages = with pkgs; [
        heroic
        steam-run
        protonup-qt
        wineWow64Packages.waylandFull
      ];

      custom.persist = {
        home.directories = [
          "Games"
          ".config/heroic"
        ];
      };
    };
}
