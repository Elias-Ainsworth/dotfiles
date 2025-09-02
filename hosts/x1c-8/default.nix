_: {
  custom = {
    qmk.enable = true;
    virtualization.enable = true;
  };

  networking.hostId = "c9f3a7de"; # required for zfs

  services = {
    # touchpad support
    libinput.enable = true;

    # vlc cast support
    avahi.enable = true;

    # thunderbolt support
    hardware.bolt.enable = true;

    # disable thumbprint reader
    fprintd.enable = false;
  };
}
