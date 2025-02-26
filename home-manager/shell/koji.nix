{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.koji ];
    shellAliases = {
      "commit" = "pre-commit && koji";
    };

    # TODO: Implement custom Koji config.
    # file = {
    #   ".config/koji/config.toml" = {
    #     force = true;
    #     text = # toml
    #       '''';
    #   };
    # };
  };
  custom.persist.home.directories = [ ".config/koji" ];
}
