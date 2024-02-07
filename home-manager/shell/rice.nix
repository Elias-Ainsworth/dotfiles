{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      asciiquarium
      cbonsai
      cmatrix
      fastfetch
      imagemagick
      nitch
      pipes-rs
      (inputs.wfetch.packages.${pkgs.system}.wfetch.override { waifu = true; })
    ];

    shellAliases = {
      neofetch = "${lib.getExe pkgs.fastfetch} --config neofetch";
    };
  };

  # create xresources
  xresources = {
    path = "${config.xdg.configHome}/.Xresources";
    properties = {
      "Xft.dpi" = 96;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.rgba" = "rgb";
      "Xft.autohint" = false;
      "Xft.hintstyle" = "hintslight";
      "Xft.lcdfilter" = "lcddefault";

      "*.font" = "JetBrainsMono Nerd Font Mono:Medium:size=12";
      "*.bold_font" = "JetBrainsMono Nerd Font Mono:Bold:size=12";
    };
  };
}
