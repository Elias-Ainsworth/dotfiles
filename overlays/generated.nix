# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.49.3";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.49.3";
      fetchSubmodules = false;
      sha256 = "sha256-ZpvSI3W2pWPy37PDT4T4NpgFSoS7bk5d59vvCL2nWnM=";
    };
  };
  swww = {
    pname = "swww";
    version = "3e2e2ba8f44469a1446138ee97d2988e22b093bf";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "3e2e2ba8f44469a1446138ee97d2988e22b093bf";
      fetchSubmodules = false;
      sha256 = "sha256-XBwgv80YfLZ70XYVEnR0nA7Rz5jP241D5FiwrTg7tDk=";
    };
    date = "2025-01-17";
  };
  wallust = {
    pname = "wallust";
    version = "94e5f76b5101dd1f9b98c1631e23a84a3e38be44";
    src = fetchgit {
      url = "https://codeberg.org/explosion-mental/wallust";
      rev = "94e5f76b5101dd1f9b98c1631e23a84a3e38be44";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-Nw769wePmW9uG03N/N7nhvcnCvx1odfOQtq2iCTY2/Q=";
    };
    date = "2025-02-02";
  };
  yazi-plugins = {
    pname = "yazi-plugins";
    version = "02d18be03812415097e83c6a912924560e4cec6d";
    src = fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "02d18be03812415097e83c6a912924560e4cec6d";
      fetchSubmodules = false;
      sha256 = "sha256-1FZ8wcf2VVp6ZWY27vm1dUU1KAL32WwoYbNA/8RUAog=";
    };
    date = "2025-01-30";
  };
  yazi-time-travel = {
    pname = "yazi-time-travel";
    version = "85baafd0b18515ccf0851e8d35f9306ec98f3c40";
    src = fetchFromGitHub {
      owner = "iynaix";
      repo = "time-travel.yazi";
      rev = "85baafd0b18515ccf0851e8d35f9306ec98f3c40";
      fetchSubmodules = false;
      sha256 = "sha256-kOpj/GJ7xIFfJDsuTvced5MYiC4ZLA0TgsqvcRnyALI=";
    };
    date = "2024-12-13";
  };
  yt-dlp = {
    pname = "yt-dlp";
    version = "2025.01.26";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.01.26";
      fetchSubmodules = false;
      sha256 = "sha256-bjvyyCvUpZNGxkFz2ce6pXDSKXJROKZphs9RV4CBs5M=";
    };
  };
}
