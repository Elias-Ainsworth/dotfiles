# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.52.3";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.52.3";
      fetchSubmodules = false;
      sha256 = "sha256-hwluSZGYRMN32dSLIe8Cs6l6R84V5fNCuHYtoc7+b00=";
    };
  };
}
