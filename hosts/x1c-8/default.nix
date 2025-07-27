_: {
  custom = {
    qmk.enable = true;
    virtualization.enable = true;
  };

  networking.hostId = "c9f3a7de"; # required for zfs

  # touchpad support
  services.libinput.enable = true;

  services.avahi.enable = true;
  # disable thumbprint reader
  services.fprintd.enable = false;
}
