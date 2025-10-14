{ lib, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  jujutsuConf = {
    user = {
      email = "pilum-murialis.toge@proton.me";
      name = "Elias Ainsworth";
    };
    ui.pager = "${lib.getExe pkgs.bat} --plain --theme base16";
    template-aliases = {
      "format_short_id(id)" = "id.shortest()";
    };
  };
in
{
  custom.wrappers = [
    (_: _prev: {
      jujutsu = {
        flags = {
          "--config-file" = tomlFormat.generate "config.toml" jujutsuConf;
        };
      };
    })
  ];

  environment.systemPackages = [ pkgs.jujutsu ];
}
