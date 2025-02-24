{
  pkgs,
  ...
}:
{
  config = {
    home = {
      packages = [ pkgs.miru ];
      file = {
        ".config/Miru/settings.json" = {
          force = true;
          text = # json
            ''
              {"angle":"default","player":"/etc/profiles/per-user/elias-ainsworth/bin/mpv","torrentPath":"/home/elias-ainsworth/Anime/"}
            '';
        };
      };
    };
    custom.persist.home.directories = [ ".config/Miru" ];
  };
}
