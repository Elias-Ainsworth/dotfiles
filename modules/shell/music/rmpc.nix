{
  flake.nixosModules.music =
    {
      inputs,
      pkgs,
      self,
      ...
    }:
    let
      rmpcConf = {
        address = "127.0.0.1:6600";
        password = null;
        enable_mouse = true;
        volume_step = 5;
      };
      rmpcConf' = # ron
        ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          ${self.lib.generators.attrsToRON rmpcConf}
        '';
      rmpc' = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.rmpc;
        flags = {
          "--config" = rmpcConf';
        };
      };
    in
    {
      environment.systemPackages = [ rmpc' ];
    };
}
