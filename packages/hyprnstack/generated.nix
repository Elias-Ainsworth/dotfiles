# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  hyprNStack = {
    pname = "hyprNStack";
    version = "30313f41b72096e65feec3381e217205163929ef";
    src = fetchFromGitHub {
      owner = "zakk4223";
      repo = "hyprNstack";
      rev = "30313f41b72096e65feec3381e217205163929ef";
      fetchSubmodules = false;
      sha256 = "sha256-OIT+Z4ixQ9jrjLkJXrQGI5jTKTddqvZp6d2BQ3ubqbg=";
    };
  };
}
