{
  lib,
  util,
  maxi,
  transparent,
  ...
}:
let
  inherit (util)
    mkClue
    mkHighlighter
    mkKeymapWithOpts
    mkTrigger
    ;
in
{
  vim = {
    # You might want to add a custom Lua configuration
    mini = lib.mkIf (!maxi) {
      ai.enable = true;
      bracketed.enable = true;
      bufremove.enable = true;
      clue = {
        enable = true;
        setupOpts = {
          clues = lib.mkForce [
            {
              miniclue.gen_clues.builtin_completion = {
                enable = true;
                g = true;
                marks = true;
                registers = true;
                windows = true;
                z = true;
              };
            }
            (mkClue "n" "gn" "I[N]it")

            (mkClue "n" "<leader>b" "[B]uffer")
            (mkClue "n" "<leader>bm" "[M]ove")
            (mkClue "n" "<leader>bs" "[S]ort")

            (mkClue "n" "<leader>G" "[G]it")

            (mkClue "n" "<leader>g" "[G]itsigns")
            (mkClue "n" "<leader>gc" "[C]hoose")
            (mkClue "n" "<leader>gd" "[D]iff")
            (mkClue "n" "<leader>gl" "Blame [L]ine")
            (mkClue "n" "<leader>gp" "[P]review Hunk")
            (mkClue "n" "<leader>gr" "[R]eset")
            (mkClue "n" "<leader>gs" "[S]tage")
            (mkClue "n" "<leader>gt" "[T]oggle")
            (mkClue "v" "<leader>g" "[G]itsigns")
            (mkClue "v" "<leader>gr" "[R]eset")
            (mkClue "v" "<leader>gs" "[S]tage")

            (mkClue "n" "<leader>l" "[L]sp")
            (mkClue "n" "<leader>la" "Code [A]ction")
            (mkClue "n" "<leader>ld" "[D]iagnostic [trouble]")
            (mkClue "n" "<leader>le" "Diagnostic [float]")
            (mkClue "n" "<leader>lf" "[F]ormat")
            (mkClue "n" "<leader>lg" "[G]oto")
            (mkClue "n" "<leader>lH" "[H]ighlight")
            (mkClue "n" "<leader>lh" "[H]over")
            (mkClue "n" "<leader>ln" "Re[N]ame")
            (mkClue "n" "<leader>lo" "Activate LSP [O]n Cursor")
            (mkClue "n" "<leader>lr" "[R]eferences [trouble]")
            (mkClue "n" "<leader>lS" "[S]ymbols")
            (mkClue "n" "<leader>ls" "[S]ignature help")
            (mkClue "n" "<leader>lt" "[T]oggle")

            (mkClue "n" "<leader>w" "[W]orkspace")
            (mkClue "n" "<leader>wh" { desc = "Move to window left"; })
            (mkClue "n" "<leader>wj" { desc = "Move to window below"; })
            (mkClue "n" "<leader>wk" { desc = "Move to window above"; })
            (mkClue "n" "<leader>wl" { desc = "Move to window right"; })
            (mkClue "n" "<leader>ws" { desc = "Split window horizontally"; })
            (mkClue "n" "<leader>wv" { desc = "Split window vertically"; })
            (mkClue "n" "<leader>wq" { desc = "Close current window"; })
            (mkClue "n" "<leader>wo" { desc = "Close all other windows"; })
            (mkClue "n" "<leader>w=" { desc = "Equalize window sizes"; })
            (mkClue "n" "<leader>w+" { desc = "Increase window height"; })
            (mkClue "n" "<leader>w-" { desc = "Decrease window height"; })
            (mkClue "n" "<leader>w>" { desc = "Increase window width"; })
            (mkClue "n" "<leader>w<" { desc = "Decrease window width"; })

            (mkClue "n" "<leader>n" "[N]eorg")
            (mkClue "n" "<leader>nw" "[W]orkpace")

            (mkClue "n" "<leader>p" "[P]ick")

            (mkClue "n" "<leader>t" "[T]odo")
            (mkClue "n" "<leader>tq" "[Q]uickFix")
            #TODO: Make this remap.
            # (mkClue "n" "<leader>tt" "[T]rouble")

            (mkClue "n" "<leader>w" "[W]indow")

            (mkClue "n" "<leader>x" "Trouble")
            (mkClue "n" "<leader>xl" "[L]OCList")
            (mkClue "n" "<leader>xq" "[Q]uickFix")
            (mkClue "n" "<leader>xs" "[S]ymbols")

            (mkClue "n" "<localleader>c" "[C]ode")
            (mkClue "n" "<localleader>d" "[D]ate")
            (mkClue "n" "<localleader>l" "[L]ist")
            (mkClue "n" "<localleader>t" "[T]oggle")
            (mkClue "n" "<localleader>n" "[N]ew")

            (mkClue "n" "<C-w>h" { desc = "Move to window left"; })
            (mkClue "n" "<C-w>j" { desc = "Move to window below"; })
            (mkClue "n" "<C-w>k" { desc = "Move to window above"; })
            (mkClue "n" "<C-w>l" { desc = "Move to window right"; })

            (mkClue "n" "<C-w>s" { desc = "Split window horizontally"; })
            (mkClue "n" "<C-w>v" { desc = "Split window vertically"; })

            (mkClue "n" "<C-w>q" { desc = "Close current window"; })
            (mkClue "n" "<C-w>o" { desc = "Close all other windows"; })

            (mkClue "n" "<C-w>=" { desc = "Equalize window sizes"; })
            (mkClue "n" "<C-w>+" { desc = "Increase window height"; })
            (mkClue "n" "<C-w>-" { desc = "Decrease window height"; })
            (mkClue "n" "<C-w>>" { desc = "Increase window width"; })
            (mkClue "n" "<C-w><" { desc = "Decrease window width"; })

          ];
          triggers = [
            (mkTrigger "n" "<leader>")
            (mkTrigger "x" "<leader>")
            (mkTrigger "v" "<leader>")

            (mkTrigger "n" "<leader>w")
            (mkTrigger "x" "<leader>w")
            (mkTrigger "v" "<leader>w")

            (mkTrigger "n" "<localleader>")
            (mkTrigger "x" "<localleader>")
            (mkTrigger "v" "<localleader>")

            (mkTrigger "n" "<C-W>")
            (mkTrigger "x" "<C-W>")
            (mkTrigger "v" "<C-W>")

            (mkTrigger "n" "g")
            (mkTrigger "x" "g")
            (mkTrigger "v" "g")

            (mkTrigger "n" "z")
            (mkTrigger "x" "z")

            (mkTrigger "n" "'")
            (mkTrigger "x" "'")

            (mkTrigger "n" "`")
            (mkTrigger "x" "`")

            (mkTrigger "n" ''"'')
            (mkTrigger "x" ''"'')

            (mkTrigger "c" "<C-R>")
            (mkTrigger "i" "<C-R>")
          ];
          window.delay = 100;
        };
      };
      comment.enable = true;
      #TODO: Currently unavailable in nvf.
      # cursorword.enable = true;
      extra.enable = true;
      files.enable = true;
      hipatterns = {
        enable = false;
        setupOpts = {
          highlighters = {
            fixme = mkHighlighter "FIXME" "MiniHipatternsFixme";
            hack = mkHighlighter "HACK" "MiniHipatternsHack";
            todo = mkHighlighter "TODO" "MiniHipatternsTodo";
            note = mkHighlighter "NOTE" "MiniHipatternsNote";

            hex_color = lib.generators.mkLuaInline ''require("mini.hipatterns").gen_highlighter.hex_color()'';

            # TODO: Get this to work.
            # base16_color =
            #   lib.generators.mkLuaInline # lua
            #     ''
            #       {
            #         pattern = "base0[%dA-F]",
            #         group = function(_, match)
            #           local words = ${lib.nvim.lua.toLuaObject colorScheme'}
            #           local hex = words[match]
            #           if hex == nil then return nil end
            #           return MiniHipatterns.compute_hex_color_group(hex, bg)
            #         end,
            #       }
            #     '';
          };
        };
      };
      icons.enable = true;
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
      snippets.enable = true;
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
      statusline.enable = true;
      surround.enable = true;
      tabline.enable = true;
      trailspace.enable = true;
    };
    keymaps = [

      # easier buffer keybind
      (mkKeymapWithOpts "n" "<leader>bd" ":lua MiniBufremove.delete()<CR>" { desc = "[D]elete Buffer"; })
      (mkKeymapWithOpts "n" "<leader>bd" ":lua MiniBufremove.unshow_in_window()<CR>" {
        desc = "[U]nshow Buffer in Window";
      })
      (mkKeymapWithOpts "n" "<leader>bu" ":lua MiniBufremove.unshow()<CR>" { desc = "[U]nshow Buffer"; })
      (mkKeymapWithOpts "n" "<leader>bw" ":lua MiniBufremove.wipeout()<CR>" {
        desc = "[W]ipeout Buffer";
      })

      # mini-pick keybinds
      (mkKeymapWithOpts "n" "<leader>/" ":Pick grep_live<CR>" { desc = "Live Grep"; })
      (mkKeymapWithOpts "n" "<leader>gC" ":Pick git_commits<CR>" { desc = "[C]ommits"; })
      (mkKeymapWithOpts "n" "<leader>gb" ":Pick git_branches<CR>" { desc = "[B]ranches"; })
      (mkKeymapWithOpts "n" "<leader>gf" ":Pick git_files<CR>" { desc = "[F]iles"; })
      (mkKeymapWithOpts "n" "<leader>gh" ":Pick git_hunks<CR>" { desc = "[H]unks"; })
      (mkKeymapWithOpts "n" "<leader>le" ":Pick diagnostic<CR>" { desc = "Diagnostic Float"; })
      (mkKeymapWithOpts "n" "<leader>pH" ":Pick help<CR>" { desc = "[H]elp"; })
      (mkKeymapWithOpts "n" "<leader>pR" ":Pick resume<CR>" { desc = "[R]esume"; })
      (mkKeymapWithOpts "n" "<leader>pb" ":Pick buffers cli<CR>" { desc = "[B]uffers"; })
      (mkKeymapWithOpts "n" "<leader>pc" ":Pick commands<CR>" { desc = "[C]ommands"; })
      (mkKeymapWithOpts "n" "<leader>pf" ":Pick files<CR>" { desc = "[F]iles"; })
      (mkKeymapWithOpts "n" "<leader>pg" ":Pick grep<CR>" { desc = "[G]rep"; })
      (mkKeymapWithOpts "n" "<leader>ph" ":Pick history<CR>" { desc = "[H]istory"; })
      (mkKeymapWithOpts "n" "<leader>pm" ":Pick marks<CR>" { desc = "[M]arks"; })
      (mkKeymapWithOpts "n" "<leader>po" ":Pick oldfiles<CR>" { desc = "[O]ldfiles"; })
      (mkKeymapWithOpts "n" "<leader>pr" ":Pick registers<CR>" { desc = "[R]egisters"; })
      (mkKeymapWithOpts "n" "<leader>ps" ":Pick spellsuggest<CR>" { desc = "[S]pellsuggest"; })
      (mkKeymapWithOpts "n" "<leader>pT" ":Pick treesitter<CR>" { desc = "[T]reesitter"; })

      # Files
      (mkKeymapWithOpts "n" "<leader>f" ":lua MiniFiles.open()<CR>" {
        desc = "[F]iles";
      })

      (mkKeymapWithOpts "n" "<leader>wh" "<C-w>h" { desc = "Move to window left"; })
      (mkKeymapWithOpts "n" "<leader>wj" "<C-w>j" { desc = "Move to window below"; })
      (mkKeymapWithOpts "n" "<leader>wk" "<C-w>k" { desc = "Move to window above"; })
      (mkKeymapWithOpts "n" "<leader>wl" "<C-w>l" { desc = "Move to window right"; })

      (mkKeymapWithOpts "n" "<leader>ws" "<C-w>s" { desc = "Split window horizontally"; })
      (mkKeymapWithOpts "n" "<leader>wv" "<C-w>v" { desc = "Split window vertically"; })

      (mkKeymapWithOpts "n" "<leader>wq" "<C-w>q" { desc = "Close current window"; })
      (mkKeymapWithOpts "n" "<leader>wo" "<C-w>o" { desc = "Close all other windows"; })

      (mkKeymapWithOpts "n" "<leader>w=" "<C-w>=" { desc = "Equalize window sizes"; })
      (mkKeymapWithOpts "n" "<leader>w+" "<C-w>+" { desc = "Increase window height"; })
      (mkKeymapWithOpts "n" "<leader>w-" "<C-w>-" { desc = "Decrease window height"; })
      (mkKeymapWithOpts "n" "<leader>w>" "<C-w>>" { desc = "Increase window width"; })
      (mkKeymapWithOpts "n" "<leader>w<" "<C-w><" { desc = "Decrease window width"; })
    ];
  };
}
