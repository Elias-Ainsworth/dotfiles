{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];
  config = {
    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      config = {
        transparent = true;
        frameless = true;
        plugins = {
          fakeNitro.enable = true;
          reverseImageSearch.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
    custom.persist.home.directories = [
      ".config/Discord"
      ".config/vesktop"
      ".config/discord"
      ".config/vencord"
    ];
  };
}
