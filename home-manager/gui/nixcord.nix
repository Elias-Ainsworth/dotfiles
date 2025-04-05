{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];
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
}
