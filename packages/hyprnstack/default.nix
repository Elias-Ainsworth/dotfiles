{
  lib,
  gcc13Stdenv,
  hyprland,
  source,
}:
gcc13Stdenv.mkDerivation (
  source
  // {
    inherit (hyprland) nativeBuildInputs;

    buildInputs = [ hyprland ] ++ hyprland.buildInputs;

    # Skip meson phases
    configurePhase = "true";
    mesonConfigurePhase = "true";
    mesonBuildPhase = "true";
    mesonInstallPhase = "true";

    buildPhase = ''
      make all
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp nstackLayoutPlugin.so $out/lib/lib${source.pname}.so
    '';

    meta = with lib; {
      homepage = "https://github.com/zakk4223/hyprNStack";
      description = "Hyprland HyprNStack Plugin";
      maintainers = with maintainers; [ iynaix ];
      platforms = platforms.linux;
    };
  }
)
