_: {
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  custom.shell.packages = {
    mkdirenv = # sh
      ''nix flake init --template github:elias-ainsworth/dotfiles#"$1"'';
    redirenv = # sh
      ''rm -r .direnv .devenv'';
  };

  custom.persist = {
    home = {
      directories = [ ".local/share/direnv" ];
      cache.directories = [ ".cache/pip" ];
    };
  };
}
