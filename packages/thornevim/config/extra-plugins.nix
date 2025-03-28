{ pkgs, ... }:
{
  vim = {
    extraPlugins = with pkgs.vimPlugins; {
      direnv = {
        package = direnv-vim;
      };
      nabla = {
        package = nabla-nvim;
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
