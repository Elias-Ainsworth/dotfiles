{
  lib,
  pkgs,
  colorscheme ? null,
  transparency ? false,
  ...
}:

let
  themeConfig = {
    name = if colorscheme == "oxocarbon" then "oxocarbon" else "catppuccin";

    style = if colorscheme == "oxocarbon" then "dark" else "mocha";

    transparent = if colorscheme == "oxocarbon" then lib.mkForce false else transparency;
  };

  transparentConfig = # lua
    ''
      require("kanagawa").setup({
          transparent = true,
          theme = "dragon",
          colors = {
              theme = {
                  all = { ui = { bg_gutter = "none" } },
              },
          },
          overrides = function(colors)
              local theme = colors.theme
              return {
                  EndOfBuffer= { bg = "none" },
                  FloatBorder = { bg = "none" },
                  FloatFooter= { bg = "none" },
                  FloatTitle = { bg = "none" },
                  MiniFilesTitle= { bg = "none" },
                  MiniFilesTitleFocused= { bg = "none" },
                  MiniPickPrompt = { bg = "none" },
                  MiniTablineFill= { bg = "none" },
                  MiniTablineVisible= { bg = "none" },
                  MiniStatuslineFilename = { bg = "none" },
                  NormalFloat = { bg = "none" },
                  StatusLine= { bg = "none" },
                  StatusLineNC= { bg = "none" },
                  Tabline = { bg = "none" },
                  TablineFill= { bg = "none" },

                  NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                  LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                  MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                  Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                  PmenuSel = { fg = "NONE", bg = "NONE" },
                  PmenuSbar = { bg = "NONE" },
                  PmenuThumb = { bg = "NONE" },
              }
          end,
      })
      vim.cmd("colorscheme kanagawa-dragon")
    '';

  nonTransparentConfig = "vim.cmd(\"colorscheme kanagawa-dragon\")";

in
{
  vim = {
    theme = {
      enable = true;
      inherit (themeConfig) transparent;
      inherit (themeConfig) name;
      inherit (themeConfig) style;
    };

    extraPlugins = with pkgs.vimPlugins; {
      kanagawa = lib.mkIf (colorscheme == "kanagawa") {
        package = kanagawa-nvim;
        setup = if transparency then transparentConfig else nonTransparentConfig;
      };
    };
  };
}
