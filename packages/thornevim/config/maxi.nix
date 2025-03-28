{
  lib,
  pkgs,
  maxi ? false,
  util,
  ...
}:
let
  inherit (util) mkKeymapWithOpts;
in
{
  vim = lib.mkIf maxi {
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
    extraPlugins = {
      oil = with pkgs.vimPlugins; {
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
    };
    autopairs.nvim-autopairs.enable = true;
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
    comments.comment-nvim.enable = true;
    snippets.luasnip.enable = true;
    statusline.lualine.enable = true;
    tabline.nvimBufferline = {
      enable = true;
      setupOpts = {
        options = {
          numbers = "none";
          show_close_icon = false;
        };
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
    ui.colorizer.enable = true;
    utility = {
      motion.leap.enable = true;
      # preview.markdownPreview.enable = true;
      surround.enable = true;
    };
    visuals.nvim-web-devicons.enable = true;
    keymaps = [
      # sane oil keybind
      (mkKeymapWithOpts "n" "<leader>o" ":Oil<CR>" { desc = "[O]il"; })

      # # sane window keybind
      (mkKeymapWithOpts [ "n" "x" ] "<leader>w" "<cmd>:WhichKey<C-W><CR>" { desc = "[W]indow"; })
    ];
  };
}
