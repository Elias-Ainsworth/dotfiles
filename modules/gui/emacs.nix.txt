{
  inputs,
  ...
}:
{
  imports = [ inputs.thornemacs.homeManagerModules.default ];

  config = {
    programs.thornemacs = {
      # TODO: Simplify emacs config.
      enable = false;
      service.enable = false;
      installAssets.enable = false;
    };
    custom.persist.home = {
      directories = [
        "org"
        ".config/emacs"
        ".emacs.d"
      ];
      # files = [ ".emacs" ];
    };
  };
}
