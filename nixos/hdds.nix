{ config, lib, ... }:
let
  inherit (lib)
    concatLines
    mkEnableOption
    mkIf
    optionals
    optionalAttrs
    ;
  inherit (config.hm.custom) mswindows;
  cfg = config.custom.hdds;
  wdred = "/media/6TBRED";
  wdred-dataset = "zfs-wdred6-1/media";
  ironwolf = "/media/IRONWOLF22";
  ironwolf-dataset = "zfs-ironwolf22-1/media";
  inherit (config.hm.home) homeDirectory;
in
{
  options.custom = {
    hdds = {
      enable = mkEnableOption "Desktop HDDs";
      wdred6 = mkEnableOption "WD Red 6TB" // {
        default = config.custom.hdds.enable;
      };
      ironwolf22 = mkEnableOption "Ironwolf Pro 22TB" // {
        default = config.custom.hdds.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    services.sanoid = {
      enable = true;

      datasets = {
        ${ironwolf-dataset} = mkIf cfg.ironwolf22 {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
        ${wdred-dataset} = mkIf cfg.wdred6 {
          hourly = 3;
          daily = 10;
          weekly = 2;
          monthly = 0;
        };
      };
    };

    # symlinks from hdds
    custom.symlinks =
      optionalAttrs cfg.ironwolf22 {
        "${homeDirectory}/Downloads" = "${ironwolf}/Downloads";
      }
      // optionalAttrs cfg.wdred6 { "${homeDirectory}/Videos" = wdred; }
      // optionalAttrs (cfg.ironwolf22 && cfg.wdred6) {
        "${wdred}/Anime" = "${ironwolf}/Anime";
        "${wdred}/Movies" = "${ironwolf}/Movies";
        "${wdred}/TV" = "${ironwolf}/TV";
      };

    hm = {
      # add bookmarks for gtk
      gtk.gtk3.bookmarks = mkIf cfg.ironwolf22 [
        "file://${ironwolf}/Anime Anime"
        "file://${ironwolf}/Anime/Current Anime Current"
        "file://${ironwolf}/TV TV"
        "file://${ironwolf}/TV/Current TV Current"
        "file://${ironwolf}/Movies"
      ];

      # add btop monitoring for extra hdds
      custom.btop.disks =
        optionals cfg.wdred6 [ "/media/6TBRED" ]
        ++ optionals cfg.ironwolf22 [ "/media/IRONWOLF22" ];
    };

    # dual boot windows
    boot = {
      loader.grub = {
        extraEntries = concatLines (
          optionals mswindows [
            ''
              menuentry "Windows 11" {
                insmod part_gpt
                insmod fat
                insmod search_fs_uuid
                insmod chain
                search --fs-uuid --set=root FA1C-F224
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
              }
            ''
          ]
        );
        # ++ (optionals cfg.archlinux [''
        #   menuentry "Arch Linux" {
        #     insmod gzio
        #     insmod part_gpt
        #     insmod fat
        #     search --no-floppy --fs-uuid --set=root 35EE-1411
        #     linux /vmlinuz-linux root=UUID=e630c4b1-075e-42a9-bd4e-894273e99ac7 rw rootflags=subvol=@ loglevel=3 quiet
        #     initrd /amd-ucode.img /initramfs-linux.img
        #   }
        # '']));
      };
    };

    # hide disks
    fileSystems = {
      # "/media/archlinux" = mkIf cfg.archlinux {
      #   device = "/dev/disk/by-uuid/e630c4b1-075e-42a9-bd4e-894273e99ac7";
      #   fsType = "btrfs";
      #   options = ["nofail" "x-gvfs-hide" "subvol=/@"];
      # };

      "/media/6TBRED" = mkIf cfg.wdred6 {
        device = "zfs-wdred6-1/media";
        fsType = "zfs";
      };

      "/media/IRONWOLF22" = mkIf cfg.ironwolf22 {
        device = "zfs-ironwolf22-1/media";
        fsType = "zfs";
      };

      "/media/windows" = mkIf mswindows {
        device = "/dev/disk/by-uuid/94F422A4F4228916";
        fsType = "ntfs-3g";
        options = [
          "nofail"
          "x-gvfs-hide"
        ];
      };

      "/media/windowsgames" = mkIf mswindows {
        device = "/dev/disk/by-label/GAMES";
        fsType = "ntfs-3g";
        options = [
          "nofail"
          "x-gvfs-hide"
        ];
      };
    };
  };
}
