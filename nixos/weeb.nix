{
  config,
  lib,
  user,
  ...
}:
let
  inherit (lib) mkIf;
in
mkIf config.custom.sops.enable {
  sops.secrets.anilist_token.owner = user;
  custom.symlinks = {
    "/home/${user}/.local/share/jerry/anilist_token.txt" = "${config.sops.secrets.anilist_token.path}";
  };
}
