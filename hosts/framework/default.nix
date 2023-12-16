{user, ...}: {
  iynaix-nixos = {
    # TODO: enable with new config for device
    kanata.enable = false;
  };

  # by-id doesn't seem to work with amd mobo
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  networking.hostId = "abb4d116"; # required for zfs

  # allow building and pushing of laptop config from desktop
  nix.settings.trusted-users = [user];

  # touchpad support
  services.xserver.libinput.enable = true;
}
