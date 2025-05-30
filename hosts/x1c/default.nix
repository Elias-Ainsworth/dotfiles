_: {
  custom = {
    distrobox.enable = true;
    virtualization.enable = true;
    qmk.enable = true;
  };

  networking.hostId = "ec7351ab"; # required for zfs

  # touchpad support
  services.libinput.enable = true;

  # disable thumbprint reader
  services.fprintd.enable = false;

  # vlc
  services.avahi.enable = true;

  services.hardware.bolt.enable = true;
}
