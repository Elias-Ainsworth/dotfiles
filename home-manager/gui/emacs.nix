{
  inputs,
  ...
}:
{
  imports = [ inputs.thornemacs.homeManagerModules.default ];

  config = {
    programs.thornemacs = {
      enable = true;
      service.enable = true;
      installAssets = true;
    };
    custom.persist.home.directories = [
      "org"
      ".config/emacs"
      ".emacs.d"
    ];
  };
}
