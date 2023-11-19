{user, ...}: {
  iynaix-nixos = {
    backlight.enable = true;
    battery.enable = true;
    kanata.enable = false;
    wifi.enable = true;
    zfs.encryption = true;
  };

  networking.hostId = "abb4d116"; # required for zfs

  # allow building and pushing of laptop config from desktop
  nix.settings.trusted-users = [user];

  # touchpad support
  services.xserver.libinput.enable = true;
}
