# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.55.5";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.55.5";
      fetchSubmodules = false;
      sha256 = "sha256-0FgLVQZBv366ACw8zXt72fARdQqFZf4l4lfvt85KpSs=";
    };
  };
}
