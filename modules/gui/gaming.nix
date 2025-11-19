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
        # steam-run
        protonup-qt
        wineWow64Packages.waylandFull
      ];

      programs.steam = {
        enable = true;
      };

      custom.persist = {
        home.directories = [
          "Games"
          ".config/heroic"
          ".steam"
          ".local/share/applications" # desktop files from steam
          ".local/share/icons/hicolor" # icons from steam
          ".local/share/Steam"
        ];
      };
    };
}
