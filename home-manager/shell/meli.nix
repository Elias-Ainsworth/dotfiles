{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.meli ];
    custom.persist.home.directories = [ ".config/meli" ];
  };
}
