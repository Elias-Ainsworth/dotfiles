{ pkgs, ... }:
{
  home.packages = [ pkgs.meli ];
  config.custom.persist.home.directories = [ ".config/meli" ];
}
