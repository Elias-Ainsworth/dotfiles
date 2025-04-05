{
  lib,
  pkgs,

  colorscheme,
  transparent,
  variant,
  ...
}:
let
  isKanagawa = colorscheme == "kanagawa";
  themeConfig = {
    name = colorscheme;
    style = variant;
    transparent = transparent;
  };
  kanagawaTransparent = # lua
    ''
      require("kanagawa").setup({
          transparent = true,
          theme = "${variant}",
          colors = {
              all = { ui = { bg_gutter = "none" } },
          },
          overrides = function(colors)
              local theme = colors.theme
              return {
                  DiagnosticSignError = { bg = "none" },
                  DiagnosticSignWarn = { bg = "none" },
                  DiagnosticSignInfo = { bg = "none" },
                  DiagnosticSignHint = { bg = "none" },

                  EndOfBuffer = { bg = "none" },

                  FloatBorder = { bg = "none" },
                  FloatFooter = { bg = "none" },
                  FloatTitle = { bg = "none" },

                  GitSignsAdd = { bg = "none" },
                  GitSignsChange = { bg = "none" },
                  GitSignsDelete = { bg = "none" },

                  LineNr = { bg = "none" },
                  LineNrAbove = { bg = "none" },
                  LineNrBelow = { bg = "none" },

                  MiniFilesTitle = { bg = "none" },
                  MiniFilesTitleFocused = { bg = "none" },

                  MiniPickPrompt = { bg = "none" },

                  MiniStatuslineFilename = { bg = "none" },

                  MiniTablineFill = { bg = "none" },
                  MiniTablineVisible = { bg = "none" },

                  NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                  NormalFloat = { bg = "none" },

                  Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                  PmenuSbar = { bg = "NONE" },
                  PmenuSel = { fg = "NONE", bg = "NONE" },
                  PmenuThumb = { bg = "NONE" },

                  SignColumn = { bg = "none" },
                  StatusLine = { bg = "none" },
                  StatusLineNC = { bg = "none" },

                  Tabline = { bg = "none" },
                  TablineFill = { bg = "none" },
              }
          end,
      })
      vim.cmd("colorscheme kanagawa-${variant}")
    '';
  kanagawaNonTransparent = "vim.cmd(\"colorscheme kanagawa-${variant}\")";
in
{
  vim = {
    theme = lib.mkIf (!isKanagawa) {
      enable = true;
      transparent = themeConfig.transparent;
      name = themeConfig.name;
      style = themeConfig.style;
    };

    extraPlugins = with pkgs.vimPlugins; {
      kanagawa = lib.mkIf isKanagawa {
        package = kanagawa-nvim;
        setup = if transparent then kanagawaTransparent else kanagawaNonTransparent;
      };
    };
  };
}
