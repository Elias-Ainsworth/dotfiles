_: {
  vim = {
    viAlias = true;
    vimAlias = true;

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

    lazy.enable = true;
  };
}
