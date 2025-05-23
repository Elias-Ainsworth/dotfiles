{ inputs, ... }:
{
  imports = [ inputs.pilum-murialis.nixosModules.default ];
  services.pilum-murialis-xyz = {
    enable = true;
    domain = "pilum-murialis.xyz";
  };

  custom = {
    distrobox.enable = true;
    virtualization.enable = true;
    qmk.enable = true;
  };

  boot.loader.grub.gfxmodeEfi = "1600x900";

  networking.hostId = "fc7351ca"; # required for zfs

  # touchpad support
  services.libinput.enable = true;

  # disable thumbprint reader
  services.fprintd.enable = false;

  services.avahi.enable = true;
}
