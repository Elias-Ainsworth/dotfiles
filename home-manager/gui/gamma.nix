{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  options.custom = {
    gamma.enable = mkEnableOption "gamma";
  };

  config.services.gammastep = {
    enable = config.custom.gamma.enable;
    latitude = 33.45;
    longitude = -112.07;
    temperature = {
      day = 4500;
      night = 3500;
    };
  };
}
