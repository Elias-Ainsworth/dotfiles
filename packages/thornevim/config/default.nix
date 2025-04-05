_: {
  # nvf options can be found at:
  # https://notashelf.github.io/nvf/options.html
  imports = [
    ./autocmds.nix
    ./extra-plugins.nix
    ./git.nix
    ./keymaps.nix
    ./languages.nix
    ./maxi.nix
    ./mini.nix
    ./neorg.nix
    ./options.nix
    ./plugins.nix
    ./theme.nix
  ];
  _module.args.util = import ./util.nix;
}
