{
  lib,
  dots ? null,
  ...
}:
{
  # nvf options can be found at:
  # https://notashelf.github.io/nvf/options.html
  imports = [
    ./keymaps.nix
    ./extra-plugins.nix
  ];

  vim = {
    viAlias = true;
    vimAlias = true;

    theme = {
      enable = true;
      transparent = true;

      # name = "catppuccin";
      # style = "mocha";
    };

    options = {
      cursorline = true;
      gdefault = true;
      magic = true;
      matchtime = 2; # briefly jump to a matching bracket for 0.2s
      exrc = true; # use project specific vimrc
      smartindent = true;
      virtualedit = "block"; # allow cursor to move anywhere in visual block mode
      # Use 4 spaces for <Tab> and :retab
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      shiftround = true; # round indent to multiple of 'shiftwidth' for > and < command
    };

    # misc meta settings
    lineNumberMode = "relNumber";
    preventJunkFiles = true;
    searchCase = "smart";
    useSystemClipboard = true;

    spellcheck = {
      enable = true;
      programmingWordlist.enable = true;
    };

    # autocmds
    luaConfigPost = # lua
      ''
        -- use default colorscheme in tty
        -- https://github.com/catppuccin/nvim/issues/588#issuecomment-2272877967
        vim.g.has_ui = #vim.api.nvim_list_uis() > 0
        vim.g.has_gui = vim.g.has_ui and (vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil)

        if not vim.g.has_gui then
          if vim.g.has_ui then
            vim.o.termguicolors = false
            vim.cmd.colorscheme('default')
          end
          return
        end

        -- remove trailing whitespace on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*",
          command = "silent! %s/\\s\\+$//e",
        })

        -- save on focus lost
        vim.api.nvim_create_autocmd("FocusLost", {
          pattern = "*",
          command = "silent! wa",
        })

        -- absolute line numbers in insert mode, relative otherwise
        vim.api.nvim_create_autocmd("InsertEnter", {
          pattern = "*",
          command = "set number norelativenumber",
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
          pattern = "*",
          command = "set number relativenumber",
        })
      '';

    dashboard = {
      startify = {
        enable = true;
        changeToVCRoot = true;
        customHeader = [
          #TODO: Make this say eepyVim
          "                                                                       "
          "                                                                     "
          "       ████ ██████           █████      ██                     "
          "      ███████████             █████                             "
          "      █████████ ███████████████████ ███   ███████████   "
          "     █████████  ███    █████████████ █████ ██████████████   "
          "    █████████ ██████████ █████████ █████ █████ ████ █████   "
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
          " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
          "                                                                       "
        ];
      };
    };

    languages = {
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;

      # TODO: misc plugins
      # * supermaven
      # luasnip

      clang.enable = true;
      bash.enable = true;
      html.enable = true;
      haskell.enable = true;
      lua.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
      nix = {
        enable = true;
        format.type = "nixfmt";
        lsp = {
          server = "nixd";
          options = lib.mkIf (dots != null) {
            nixos = {
              expr = "(builtins.getFlake \"${dots}\").nixosConfigurations.desktop.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${dots}\").homeConfigurations.desktop.options";
            };
          };
        };
      };
      ocaml.enable = true;
      python.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };
      tailwind.enable = true;
      ts = {
        enable = true;
        extensions.ts-error-translator.enable = true;
        # lsp.server = "denols"; # enable for deno?
      };
    };

    lsp = {
      formatOnSave = true;
      # lightbulb.enable = true;
      lspkind.enable = true;
      otter-nvim.enable = true; # provide lsp for embedded languages
      trouble.enable = true;
      # lspSignature?
      # mappings?
      mappings = {
        goToDefinition = "gd";
      };
    };

    autocomplete.nvim-cmp = {
      enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
      };
    };
    autopairs.nvim-autopairs.enable = true;
    binds.whichKey = {
      enable = true;
      register = {
        # Leader
        #TODO: Set <leader>a to not show when the option is available.
        # "<leader>a" = "";
        "<leader>gc" = "+Conflict";
        "<leader>gd" = "+Diff";
        "<leader>gr" = "+Reset";
        "<leader>gs" = "+Stage";
        "<leader>gt" = "+Toggle";
        "<leader>G" = "+Git";
        # "<leader>h" = "+Harpoon";
        "<leader>l" = "+LSP";
        "<leader>n" = "+Neorg";
        "<leader>nw" = "+Workspaces";
        "<leader>o" = "+Oil";
        "<leader>t" = "+Todo";
        # Local Leader
        ",c" = "+Code";
        ",i" = "+Insert";
        ",l" = "+List";
        ",n" = "+Note";
        ",t" = "+Todo";
      };
      #NOTE: If I feel like it:
      # setupOpts = {
      #   preset = "helix";
      # };
    };
    comments.comment-nvim.enable = true;
    git = {
      enable = true;
      git-conflict = {
        mappings = {
          both = "<leader>gcb";
          none = "<leader>gc0";
          ours = "<leader>gco";
          theirs = "<leader>gct";
        };
      };
      gitsigns = {
        mappings = {
          blameLine = "<leader>gl";
          diffProject = "<leader>gdp";
          diffThis = "<leader>gdt";
          previewHunk = "<leader>gp";
          resetBuffer = "<leader>grb";
          resetHunk = "<leader>grh";
          stageBuffer = "<leader>gsb";
          stageHunk = "<leader>gsh";
          toggleBlame = "<leader>gtb";
          toggleDeleted = "<leader>gtd";
          undoStageHunk = "<leader>gsu";
        };
      };
    };
    # globals.maplocalleader = "m";
    lazy.enable = true;
    navigation.harpoon = {
      enable = true;
      mappings = {
        #NOTE: Uncomment `whichKey.register."<leader>h" = "+Harpoon";` if using the below.
        # file1 = "<leader>hn";
        # file2 = "<leader>he";
        # file3 = "<leader>hi";
        # file4 = "<leader>ho";
        # listMarks = "<leader>hl";
        # markFile = "<leader>ha";

        file1 = "<M-n>";
        file2 = "<M-e>";
        file3 = "<M-i>";
        file4 = "<M-o>";
        listMarks = "<M-t>";
        markFile = "<M-s>";
      };
    };
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
      todo-comments = {
        enable = true;
        mappings = {
          telescope = "<leader>tt";
          trouble = "<leader>tr";
          quickFix = "<leader>tq";
        };
      };
    };
    projects.project-nvim = {
      enable = true;
      setupOpts = {
        detection_methods = [
          "lsp"
          "pattern"
        ];
        patterns = [
          "=.envrc"
          "=flake.nix"
          "=.norg"
          ">projects/"
          ">playground/"
        ];
      };
    };
    snippets.luasnip.enable = true;
    statusline.lualine.enable = true;
    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options = {
        numbers = "none";
        show_close_icon = false;
      };
    };
    telescope = {
      enable = true;
      mappings = {
        buffers = "<leader>fb";
        findFiles = "<leader>ff";
        gitBranches = "<leader>gb";
        gitStatus = "<leader>gT";
        liveGrep = "<leader>/";
      };
      setupOpts = {
        defaults = {
          mappings = {
            i."<S-BS>" = lib.generators.mkLuaInline "require('telescope.actions').delete_buffer";
            n."dd" = lib.generators.mkLuaInline "require('telescope.actions').delete_buffer";
          };
        };
      };
    };
    treesitter.autotagHtml = true;
    ui = {
      colorizer.enable = true;
      smartcolumn.enable = true;
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
      motion.leap.enable = true;
      # preview.markdownPreview.enable
      surround.enable = true;
    };
    visuals.nvim-web-devicons.enable = true;
  };
}
