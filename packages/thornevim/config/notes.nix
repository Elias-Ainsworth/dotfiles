_: {
  vim = {
    notes = {
      neorg = {
        enable = true;
        #BUG: Summary module doesn't work due to lack of norg-meta parser.
        treesitter.enable = true;
        setupOpts = {
          load = {
            "core.defaults".enable = true;

            "core.completion" = {
              enable = true;
              config.engine = "nvim-cmp";
            };
            "core.concealer" = {
              enable = true;
              config = {
                folds = true;
                init_open_folds = "auto";
              };
            };
            "core.dirman" = {
              enable = true;
              config = {
                workspaces = {
                  notes = "~/projects/notes";
                  blog = "~/projects/blog";
                  dotfiles = "~/projects/dotfiles";
                };
                index = "index.norg";
              };
            };
            "core.esupports.metagen" = {
              timezone = "local";
              type = "auto";
              update_date = true;
            };
            "core.export" = {
              enable = true;
              config.export_dir = "${builtins.getEnv "PWD"}";
            };
            "core.export.markdown" = {
              enable = true;
              config.extensions = "all";
            };
            "core.integrations.image".enable = true;
            "core.latex.renderer" = {
              enable = false;
              config = {
                conceal = true;
                render_on_enter = true;
                renderer = "core.integrations.image";
              };
            };
            "core.presenter" = {
              enable = true;
              config.zen_mode = "zen-mode";
            };
            "core.summary".enable = true;
          };
        };
      };
    };
    utility = {
      images.image-nvim = {
        enable = true;
        setupOpts = {
          backend =
            # if builtins.getEnv == "tmux-256color" then "ueberzug" else
            "kitty";
          integrations = {
            neorg = {
              enable = true;
              clearInInsertMode = true;
              downloadRemoteImages = true;
              filetypes = [ "norg" ];
            };
          };
        };
      };
    };
  };
}
