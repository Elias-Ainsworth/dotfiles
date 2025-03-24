{ pkgs, ... }:
{
  vim = {
    extraPlugins = with pkgs.vimPlugins; {
      direnv = {
        package = direnv-vim;
      };
      kanagawa = {
        package = kanagawa-nvim;
        setup = # lua
          ''
            require("kanagawa").setup({
                transparent = true,
                theme = "dragon",
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },

                        -- Save an hlgroup with dark background and dimmed foreground
                        -- so that you can use it where your still want darker windows.
                        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                        -- Popular plugins that open floats will link to NormalFloat by default;
                        -- set their background accordingly if you wish to keep them dark and borderless
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                        -- Telescope
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = "none"--[[ theme.ui.bg_p1 ]] },
                        TelescopePromptBorder = { fg = theme.ui.bg_dim, bg = "none"--[[ theme.ui.bg_p1 ]] },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = "none"--[[ theme.ui.bg_m1 ]] },
                        TelescopeResultsBorder = { fg = theme.ui.bg_dim, bg = "none"--[[ theme.ui.bg_m1 ]] },
                        TelescopePreviewNormal = { bg = "none"--[[ theme.ui.bg_dim  ]]},
                        TelescopePreviewBorder = { bg = "none"--[[ theme.ui.bg_dim ]], fg = theme.ui.bg_dim },

                        -- Popup menu
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1,  blend = vim.o.pumblend },  -- add `blend = vim.o.pumblend` to enable transparency
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa-dragon")
          '';
      };
      nabla = {
        package = nabla-nvim;
      };
      oil = {
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
    };
  };
}
