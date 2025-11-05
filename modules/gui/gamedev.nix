{
  flake.nixosModules.game-dev =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.godot ];
      custom.persist = {
        home.directories = [ ];
      };
    };
}
