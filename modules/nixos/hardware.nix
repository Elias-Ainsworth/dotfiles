{
  config,
  isLaptop,
  lib,
  ...
}:
{
  options.custom = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth" // {
      default = isLaptop;
    };
    hdds = {
      enable = lib.mkEnableOption "Desktop HDDs";
      wdred6 = lib.mkEnableOption "WD Red 6TB" // {
        default = config.custom.hdds.enable;
      };
      ironwolf22 = lib.mkEnableOption "Ironwolf Pro 22TB" // {
        default = config.custom.hdds.enable;
      };
      windows = lib.mkEnableOption "Windows" // {
        default = config.custom.hdds.enable;
      };
    };
    nvidia.enable = lib.mkEnableOption "Nvidia GPU";
    qmk.enable = lib.mkEnableOption "QMK";
    zfs = {
      encryption = lib.mkEnableOption "zfs encryption" // {
        default = true;
      };
    };
  };
}
