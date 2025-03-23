_: {
  #TODO: Ghostty integration
  programs = {
    nushell = {
      enable = true;
    };
  };

  custom.persist = {
    home = {
      cache.directories = [
        ".config/nushell"
      ];
    };
  };
}
