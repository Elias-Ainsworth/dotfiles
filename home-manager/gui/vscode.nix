{
  config,
  lib,
  pkgs,
  # vscode-utils,
  ...
}:
let
  inherit (lib) mkIf;
  # inherit (vscode-utils) buildVscodeMarketplaceExtension;
  # metaphore.kanagawa-vscode-color-theme = buildVscodeMarketplaceExtension {
  #   mktplcRef = {
  #     name = "kanagawa-vscode-color-theme";
  #     publisher = "metaphore";
  #     version = "0.5.0";
  #     hash = lib.fakeHash;
  #   };
  #   meta = {
  #     description = "A port of the Kanagawa Neovim color theme for Visual Studio Code, including all three flavors Wave, Dragon and Lotus.";
  #     downloadPage = "https://open-vsx.org/extension/metaphore/kanagawa-vscode-color-theme";
  #     homepage = "https://github.com/metapho-re/kanagawa-vscode-theme";
  #     license = lib.licenses.mit;
  #     maintainers = [ ];
  #   };
  # };
in
mkIf (!config.custom.headless) {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      bbenoist.nix
      bradlc.vscode-tailwindcss
      catppuccin.catppuccin-vsc
      christian-kohler.npm-intellisense
      dbaeumer.vscode-eslint
      denoland.vscode-deno
      donjayamanne.githistory
      eamodio.gitlens
      esbenp.prettier-vscode
      formulahendry.auto-rename-tag
      graphql.vscode-graphql-syntax
      gruntfuggly.todo-tree
      jnoortheen.nix-ide
      metaphore.kanagawa-vscode-color-theme
      mhutchie.git-graph
      mkhl.direnv
      ms-python.black-formatter
      ms-python.flake8
      ms-python.vscode-pylance
      pkief.material-icon-theme
      prisma.prisma
      rust-lang.rust-analyzer
      sumneko.lua
      supermaven.supermaven
      tamasfe.even-better-toml
      usernamehw.errorlens
      vscodevim.vim
      xadillax.viml
      yzhang.markdown-all-in-one
    ];
  };

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  custom.shell.packages = {
    rofi-edit-proj = {
      text = # sh
        ''
          proj_dir="/persist${config.home.homeDirectory}/projects";
          projects=$(find "$proj_dir" -maxdepth 1 -type d | sort | sed "s|$proj_dir||" | grep -v "^$" | sed 's|^/||')

          selected=$(echo "$projects" | rofi -dmenu -i -p "Open Project:")

          # Check if a project was selected
          if [ -z "$selected" ]; then
              echo "No project selected"
              exit 0
          fi

          # Open the project in VS Code
          codium "$proj_dir/$selected"
        '';
    };
  };

  custom.persist = {
    home.directories = [
      ".config/VSCodium"
      ".supermaven"
      ".vscode-oss"
    ];
  };
}
