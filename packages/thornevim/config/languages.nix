{
  lib,

  dots,
  ...
}:
{
  vim = {
    languages = {
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;

      clang.enable = true;
      bash.enable = true;
      go.enable = true;
      html.enable = true;
      haskell.enable = true;
      lua.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
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
      odin.enable = true;
      python.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
        dap.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
      tailwind.enable = true;
      ts = {
        enable = true;
        extensions.ts-error-translator.enable = true;
        # lsp.server = "denols"; # enable for deno?
      };
      typst = {
        enable = true;
        extensions.typst-preview-nvim.enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
      zig.enable = true;
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
    treesitter = {
      autotagHtml = true;
      fold = true;
    };
  };
}
