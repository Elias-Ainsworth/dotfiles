_: {
  vim = {
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
  };
}
