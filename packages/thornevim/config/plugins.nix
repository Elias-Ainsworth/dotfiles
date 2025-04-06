{
  lib,
  maxi,
  transparent,
  ...
}:
{
  vim = {
    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
      };
      setupOpts = {
        keymap.preset = "enter";
        cmdline.keymap.preset = "enter";
        completion.list.selection.preselect = false;
      };
    };
    binds.whichKey = {
      enable = true;
      register = {
        # Leader
        #TODO: Set <leader>a to not show when the option is available.
        # "<leader>a" = "";
        "<leader>gc" = "[C]onflict";
        "<leader>gd" = "[D]iff";
        "<leader>gr" = "[R]eset";
        "<leader>gs" = "[S]tage";
        "<leader>gt" = "[T]oggle";
        "<leader>G" = "[G]it";
        "<leader>l" = "[L]SP";
        "<leader>n" = "[N]eorg";
        "<leader>nw" = "[W]orkspaces";
        "<leader>o" = "[O]il";
        "<leader>t" = "[T]odo";
        # Local Leader
        ",c" = "[C]ode";
        ",i" = "[I]nsert";
        ",l" = "[L]ist";
        ",n" = "[N]ote";
        ",t" = "[T]odo";
      };
      setupOpts = {
        preset = "helix";
      };
    };
    formatter.conform-nvim.enable = true;
    mini = lib.mkIf (!maxi) {
      ai.enable = true;
      bracketed.enable = true;
      bufremove.enable = true;
      comment.enable = true;
      #TODO: Currently unavailable in nvf.
      # cursorword.enable = true;
      extra.enable = true;
      files.enable = true;
      indentscope.enable = true;
      jump.enable = true;
      jump2d = {
        enable = true;
        setupOpts = {
          mappings.start_jumping = "m";
        };
      };
      move.enable = true;
      notify = {
        enable = true;
        setupOpts = lib.mkIf transparent {
          window.winblend = 0;
        };
      };
      operators.enable = true;
      pairs.enable = true;

      #TODO: Make a picker to search through todo-comments.
      pick.enable = true;
      splitjoin.enable = true;
      starter = {
        enable = true;
        setupOpts = {
          header = builtins.readFile ../ascii/elias.txt;
          # footer = "#[derive(Dumb)]";
          footer = ''
            「僕はエリアス・エインズワースかもしれないが、
                      チセがいない――つまり、僕は完全に『チセレス』だ。」'';
        };

      };
      surround.enable = true;
      trailspace.enable = true;
    };
    navigation.harpoon = {
      enable = true;
      mappings = {
        file1 = "<M-n>";
        file2 = "<M-e>";
        file3 = "<M-i>";
        file4 = "<M-o>";
        listMarks = "<M-t>";
        markFile = "<M-s>";
      };
    };
    notes.todo-comments = {
      enable = true;
      mappings = {
        telescope = "<leader>tt";
        trouble = "<leader>tr";
        quickFix = "<leader>tq";
      };
    };
    presence.neocord = {
      enable = true;
      setupOpts = {
        logo = "https://raw.githubusercontent.com/Elias-Ainsworth/thornevim/refs/heads/main/pkgs/nvf.svg";
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
    statusline.lualine = {
      enable = true;
      setupOpts = {
        options = {
          icons_enabled = true;
          theme = "auto";
          disabled_filetypes = {
            statusline = [ "ministarter" ];
            winbar = [ "ministarter" ];
          };
          ignore_focus = { };
          always_divide_middle = true;
          always_show_tabline = true;
          globalstatus = false;
          refresh = {
            statusline = 100;
            tabline = 100;
            winbar = 100;
          };
        };
      };
    };
    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options = {
        numbers = "none";
        show_close_icon = false;
      };
    };
    telescope = {
      enable = maxi;
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
    ui = {
      colorizer.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts = {
          disabled_filetypes = [ "ministarter" ];
        };
      };
    };
    utility.preview.markdownPreview.enable = true;
    visuals.nvim-web-devicons.enable = true;
  };
}
