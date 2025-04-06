{ util, ... }:
let
  inherit (util) mkKeymap mkKeymapWithOpts;
in
{
  vim = {
    keymaps = [
      # disable arrow keys in normal mode
      (mkKeymap "n" "<up>" "<nop>")
      (mkKeymap "n" "<down>" "<nop>")
      (mkKeymap "n" "<left>" "<nop>")
      (mkKeymap "n" "<right>" "<nop>")
      # fix page up and page down so the cursor doesn't move
      (mkKeymap "n" "<PageUp>" "<C-U>")
      (mkKeymap "n" "<PageDown>" "<C-D>")
      (mkKeymap "i" "<PageUp>" "<C-O><C-U>")
      (mkKeymap "i" "<PageDown>" "<C-O><C-D>")
      # ctrl-s to save
      (mkKeymap "n" "<C-S>" ":w<CR>")
      (mkKeymap "i" "<C-S>" "<C-O>:up<CR>")
      (mkKeymap "v" "<C-S>" "<C-C>:up<CR>")
      # H to go to the beginning of the line
      (mkKeymap [ "n" "v" "x" ] "H" "^")
      # L to go to the end of the line
      (mkKeymap [ "n" "v" "x" ] "L" "$")
      # Y copies to end of line
      (mkKeymap "n" "Y" "y$")
      # keep cursor in place when joining lines
      (mkKeymap "n" "J" "mzJ`z")
      # visual shifting (does not exit visual mode)
      (mkKeymap "v" "<" "<gv")
      (mkKeymap "v" ">" ">gv")
      # copy and paste to clipboard
      (mkKeymap "v" "<C-C>" ''"+y'')
      (mkKeymap "n" "<C-V>" ''"+P'')
      (mkKeymap "i" "<C-V>" ''<C-O>"+P'')
      # replace highlighted text when pasting
      (mkKeymap "v" "<C-V>" ''"+P'')
      # automatically jump to end of text pasted
      (mkKeymapWithOpts "v" "y" "y`]" { silent = true; })
      (mkKeymapWithOpts "v" "p" "p`]" { silent = true; })
      (mkKeymapWithOpts "n" "p" "p`]" { silent = true; })
      # reselect text
      (mkKeymap "v" "gV" "`[v`]")
      # disable F1 key
      (mkKeymap "n" "<F1>" "<Esc>")
      (mkKeymap "i" "<F1>" "<Esc>")
      (mkKeymap "v" "<F1>" "<Esc>")
      # TODO: disable manual key k?
      # jk or kj to escape insert mode
      (mkKeymap "i" "jk" "<Esc>")
      (mkKeymap "i" "kj" "<Esc>")
      # center display after searches
      (mkKeymap "n" "n" "nzzzv")
      (mkKeymap "n" "N" "Nzzzv")
      (mkKeymap "n" "*" "*zzzv")
      (mkKeymap "n" "#" "#zzzv")
      (mkKeymap "n" "g*" "g*zzzv")
      (mkKeymap "n" "g#" "g#zzzv")
      # only jumps of more than 5 lines are added to the jumplist
      (mkKeymapWithOpts "n" "k" "(v:count > 5 ? \"m'\" . v:count : \"\") . 'k'" { expr = true; })
      (mkKeymapWithOpts "n" "j" "(v:count > 5 ? \"m'\" . v:count : \"\") . 'j'" { expr = true; })
      # vv enter visual block mode
      (mkKeymap "n" "vv" "<C-V>")
      # ; is an alias for :
      (mkKeymap "n" ";" ":")
      # better command line editing
      (mkKeymap "c" "<C-A>" "<Home>")
      (mkKeymap "c" "<C-E>" "<End>")
      # easier buffer navigation
      (mkKeymap "n" "<Tab>" ":bnext<CR>")
      (mkKeymap "n" "<S-Tab>" ":bprevious<CR>")
      # swap functionality of gj and gk
      (mkKeymap "n" "j" "gj")
      (mkKeymap "n" "k" "gk")
      (mkKeymap "n" "gj" "j")
      (mkKeymap "n" "gk" "k")
      # remap go to url under cursor
      (mkKeymapWithOpts "n" "gX"
        ''
          function()
            local url = vim.fn.expand('<cfile>')
            vim.fn.jobstart({'xdg-open', url}, {detach = true})
          end
        ''
        {
          desc = "Goto URL";
          lua = true;
          silent = true;
        }
      )
      # better quickfix navigation
      (mkKeymap "n" "<C-J>" ":cnext<CR>")
      (mkKeymap "n" "<C-K>" ":cprevious<CR>")
      # vim fugitive
      (mkKeymapWithOpts "n" "<leader>Gf" ":G<CR>" { desc = "[F]ugitive"; })
      (mkKeymapWithOpts "n" "<leader>Gp" ":belowright 10 split | terminal pre-commit<CR>" {
        desc = "[P]re-Commit";
      })

      # nabla
      (mkKeymapWithOpts "n" "<leader>ll" ":lua require('nabla').popup()<CR>" { desc = "Nabla"; })

      # neorg
      (mkKeymapWithOpts "n" "<C-M-s>" "<Plug>(neorg.qol.todo-items.todo.task-cycle)" {
        desc = "Cycle Task [neorg]";
      })
      (mkKeymapWithOpts "n" "<leader>ni" "<cmd>:Neorg index<CR>" { desc = "[I]ndex"; })
      (mkKeymapWithOpts "n" "<leader>nj" "<cmd>:Neorg journal<CR>" { desc = "[J]ournal"; })
      (mkKeymapWithOpts "n" "<leader>nr" "<cmd>:Neorg return<CR>" { desc = "[R]eturn"; })
      (mkKeymapWithOpts "n" "<leader>nwb" "<cmd>:Neorg workspace blog<CR>" { desc = "[B]log"; })
      (mkKeymapWithOpts "n" "<leader>nwd" "<cmd>:Neorg workspace dotfiles<CR>" { desc = "[D]otfiles"; })
      (mkKeymapWithOpts "n" "<leader>nwn" "<cmd>:Neorg workspace notes<CR>" { desc = "[N]otes"; })

      # sane tmux resize-pane keybinds
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-h>" "silent !tmux resize-pane -L 5<CR>" {
        silent = true;
        desc = "[L]eft";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-j>" "silent !tmux resize-pane -D 5<CR>" {
        silent = true;
        desc = "[D]own";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-k>" "silent !tmux resize-pane -U 5<CR>" {
        silent = true;
        desc = "[U]p";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-l>" "silent !tmux resize-pane -R 5<CR>" {
        silent = true;
        desc = "[R]ight";
      })

      # Resize windows with Ctrl+Alt+hjkl
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-h>" ":vertical resize -5<CR>" {
        silent = true;
        desc = "Resize window left";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-j>" ":resize +5<CR>" {
        silent = true;
        desc = "Resize window down";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-k>" ":resize -5<CR>" {
        silent = true;
        desc = "Resize window up";
      })
      (mkKeymapWithOpts [ "i" "n" "v" "x" ] "<C-M-l>" ":vertical resize +5<CR>" {
        silent = true;
        desc = "Resize window right";
      })
    ];
  };
}
