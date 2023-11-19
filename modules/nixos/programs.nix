{
  config,
  isLaptop,
  lib,
  ...
}: let
  cfg = config.iynaix-nixos;
in {
  options.iynaix-nixos = {
    ### NIXOS LEVEL OPTIONS ###
    distrobox.enable = lib.mkEnableOption "distrobox";
    docker.enable = lib.mkEnableOption "docker" // {default = cfg.distrobox.enable;};
    hyprland = {
      enable = lib.mkEnableOption "hyprland (nixos)" // {default = true;};
      plugin = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum ["hyprnstack"]);
        description = "Plugin to enable for hyprland";
        default = "hyprnstack";
      };
    };
    kanata.enable = lib.mkEnableOption "kanata" // {default = isLaptop;};
    sops.enable = lib.mkEnableOption "sops" // {default = true;};
    syncoid.enable = lib.mkEnableOption "syncoid";
    torrenters.enable = lib.mkEnableOption "Torrenting Applications";
    vercel.enable = lib.mkEnableOption "Vercel Backups";
    virt-manager.enable = lib.mkEnableOption "virt-manager";
  };
}
