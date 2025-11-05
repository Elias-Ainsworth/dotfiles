{ inputs, ... }:
{
  flake.nixosModules.core =
    { pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
      jujutsuConf = {
        user = {
          name = "Elias Ainsworth";
          email = "pilum-murialis.toge@proton.me";
        };
        template-aliases = {
          "format_short_id(id)" = "id.shortest()";
        };
      };
      # doesn't make sense to expose with user details
      jujutsu' = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.jujutsu;
        flags = {
          "--config-file" = tomlFormat.generate "config.toml" jujutsuConf;
        };
      };
    in
    {
      environment.systemPackages = [ jujutsu' ];
    };
}
