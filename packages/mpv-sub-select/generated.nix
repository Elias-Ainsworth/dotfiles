# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  mpv-sub-select = {
    pname = "mpv-sub-select";
    version = "26d24a0fd1d69988eaedda6056a2c87d0a55b6cb";
    src = fetchFromGitHub {
      owner = "CogentRedTester";
      repo = "mpv-sub-select";
      rev = "26d24a0fd1d69988eaedda6056a2c87d0a55b6cb";
      fetchSubmodules = false;
      sha256 = "sha256-+eVga4b7KIBnfrtmlgq/0HNjQVS3SK6YWVXCPvOeOOc=";
    };
    date = "2025-04-04";
  };
}
