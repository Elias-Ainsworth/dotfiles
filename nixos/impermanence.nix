{
  config,
  user,
  lib,
  ...
}:
let
  cfg = config.custom-nixos.persist;
  homeDir = config.hm.home.homeDirectory;
in
{
  boot = {
    # clear /tmp on boot
    tmp.cleanOnBoot = true;

    # root / home filesystem is destroyed and rebuilt on every boot:
    # https://grahamc.com/blog/erase-your-darlings
    initrd.postDeviceCommands = lib.mkAfter ''
      ${lib.optionalString (!cfg.tmpfs && cfg.erase.root) "zfs rollback -r zroot/root@blank"}
      ${lib.optionalString (!cfg.tmpfs && cfg.erase.home) "zfs rollback -r zroot/home@blank"}
    '';
  };

  # create and fix directory permissions so home-manager doesn't error out
  systemd.services.fix-mount-permissions =
    let
      createOwnedDir = dir: ''
        mkdir -p ${dir}
        chown ${user}:users ${dir}
        chmod 700 ${dir}
      '';
    in
    {
      script =
        ''
          ${createOwnedDir "/persist/cache"}
        ''
        + lib.optionalString (!cfg.tmpfs && cfg.erase.home) ''
          # required for home-manager to create its own profile to boot
          ${(createOwnedDir "${config.hm.xdg.stateHome}/nix/profiles")}
          ${"chown -R ${user}:users ${homeDir}"}
        '';
      wantedBy = [ "multi-user.target" ];
    };

  # replace root and /or home filesystems with tmpfs
  fileSystems."/" = lib.mkIf (cfg.tmpfs && cfg.erase.root) (
    lib.mkForce {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=1G"
        "mode=755"
      ];
    }
  );
  # ${homeDir} causes infinite recursion
  fileSystems."/home/${user}" = lib.mkIf (cfg.tmpfs && cfg.erase.home) (
    lib.mkForce {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=1G"
        "mode=777"
      ];
    }
  );

  # shut sudo up
  security.sudo.extraConfig = "Defaults lecture=never";

  # setup persistence
  environment.persistence = {
    "/persist" = {
      hideMounts = true;
      files = [ "/etc/machine-id" ] ++ cfg.root.files;
      directories = [
        # systemd journal is stored in /var/log/journal
        "/var/log"
      ] ++ cfg.root.directories;
    };

    "/persist/cache" = {
      hideMounts = true;
      directories = cfg.root.cache;
    };
    # NOTE: *DO NOT* persist anything from home directory as it causes a race condition
  };

  # setup persistence for home manager
  programs.fuse.userAllowOther = true;
  hm =
    hmCfg:
    let
      hmPersistCfg = hmCfg.config.custom.persist;
    in
    {
      systemd.user.startServices = true;
      home.persistence = {
        "/persist${homeDir}" = {
          allowOther = true;
          removePrefixDirectory = false;
          files = cfg.home.files ++ hmPersistCfg.home.files;
          directories = [
            {
              directory = "projects";
              method = "symlink";
            }
            ".cache/dconf"
            ".config/dconf"
          ] ++ cfg.home.directories ++ hmPersistCfg.home.directories;
        };
        "/persist/cache" = {
          allowOther = true;
          removePrefixDirectory = false;
          directories = hmPersistCfg.home.cache;
        };
      };
    };
}
