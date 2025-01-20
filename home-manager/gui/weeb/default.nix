_: {
  imports = [
    ./jerry.nix
    ./mangal.nix
    ./miru.nix
  ];

  custom.persist.home.directories = [ "Anime" ];
}
