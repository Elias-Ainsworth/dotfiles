# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  hyprNStack = {
    pname = "hyprNStack";
    version = "0eb3c1fee1f33c632498dc598488412133ca5e3c";
    src = fetchFromGitHub {
      owner = "zakk4223";
      repo = "hyprNstack";
      rev = "0eb3c1fee1f33c632498dc598488412133ca5e3c";
      fetchSubmodules = false;
      sha256 = "sha256-DKHudLsH28QwOkx3TVgo78trlAB1QCw/J0jAuDyiqZ8=";
    };
  };
}
