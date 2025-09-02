{ inputs, ... }:
{
  imports = [ inputs.pilum-murialis.nixosModules.default ];

  custom = {
    distrobox.enable = true;
    virtualization.enable = true;
    qmk.enable = true;
  };

  boot.loader.grub.gfxmodeEfi = "1600x900";

  networking.hostId = "fc7351ca"; # required for zfs

  services = {
    # touchpad support
    libinput.enable = true;

    # disable thumbprint reader
    fprintd.enable = false;

    avahi.enable = true;

    # website
    pilum-murialis-xyz = {
      enable = true;
      domain = "pilum-murialis.xyz";
      contentRepo = "https://github.com/Elias-Ainsworth/blog.pilum-murialis.xyz";
      # email = "pilum-murialis.toge@gmail.com";
    };
  };
}
