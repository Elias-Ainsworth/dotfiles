{
  config,
  lib,
  ...
}: let
  cfg = config.iynaix.persist.tmpfs;
in {
  config = lib.mkIf config.iynaix.zfs.enable {
    fileSystems."/" = lib.mkIf cfg.root (lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=3G" "mode=755"];
    });

    fileSystems."/home" = lib.mkIf cfg.home (lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=5G" "mode=755"];
    });
  };
}
