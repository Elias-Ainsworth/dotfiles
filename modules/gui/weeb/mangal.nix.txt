{
  pkgs,
  ...
}:
{
  config = {
    home = {
      packages = [ pkgs.mangal ];
      file = {
        ".config/mangal/mangal.toml" = {
          force = true;
          text = # toml
            ''
              downloader.path = "$HOME/Books/Manga"
              downloader.create_manga_dir = true
              downloader.create_volume_dir = true
              downloader.download_cover = true
              mangadex.nsfw = false # to hell with degeneracy...it'll land you in hell literally
            '';
        };
      };
    };
    custom.persist.home.directories = [ ".config/mangal" ];
  };
}
