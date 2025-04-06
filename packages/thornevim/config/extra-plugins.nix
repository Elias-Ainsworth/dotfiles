{
  maxi,
  lib,
  pkgs,
  ...
}:
{
  vim = {
    extraPlugins = with pkgs.vimPlugins; {
      direnv = {
        package = direnv-vim;
      };
      nabla = {
        package = nabla-nvim;
      };
      oil = lib.mkIf maxi {
        package = oil-nvim;
        setup = # lua
          ''
            require('oil').setup({
                    keymaps = {
                      ["K"] = "actions.parent",
                      ["J"] = "actions.select",
                    },
                  })
          '';
      };
      rooter = {
        package = vim-rooter;
      };
      vim-tmux-navigator = {
        package = vim-tmux-navigator;
      };
      wakatime = {
        package = vim-wakatime;
      };
    };
  };
}
