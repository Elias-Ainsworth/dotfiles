{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  # software rendering workaround for nvidia, see:
  # https://github.com/SoftFever/OrcaSlicer/issues/6433#issuecomment-2552029299
  nvidiaSoftwareRenderingWorkaround =
    bin: pkg:
    if (host == "desktop") then
      pkgs.symlinkJoin {
        name = bin;
        paths = [ pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/${bin} \
            --set __GLX_VENDOR_LIBRARY_NAME mesa \
            --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
        meta.mainProgram = bin;
      }
    else
      pkg;
in
{
  options.custom = with lib; {
    # option not called 3dprinting because of attribute name restrictions
    printing3d.enable = mkEnableOption "3d printing";
    modelling3d.enable = mkEnableOption "3d modelling";
  };

  config = lib.mkIf (!config.custom.headless) (
    lib.mkMerge [
      # slicers
      (lib.mkIf config.custom.printing3d.enable {
        home.packages = with pkgs; [
          # orca-slicer doesn't show the prepare / preview pane on nvidia 565:
          # https://github.com/SoftFever/OrcaSlicer/issues/6433#issuecomment-2552029299
          (nvidiaSoftwareRenderingWorkaround "orca-slicer" orca-slicer)
        ];

        # allow orca-slicer to be open bambu studio links
        xdg.mimeApps.defaultApplications = {
          "x-scheme-handler/orcaslicer" = "OrcaSlicer.desktop";
          "x-scheme-handler/bambustudio" = "OrcaSlicer.desktop";
        };

        custom.persist = {
          home = {
            directories = [
              ".config/OrcaSlicer"
            ];
          };
        };
      })
      # CAD
      (lib.mkIf config.custom.modelling3d.enable {
        home.packages = with pkgs; [
          # freecad segfaults on starup on nvidia
          # https://github.com/NixOS/nixpkgs/issues/366299
          (nvidiaSoftwareRenderingWorkaround "FreeCAD" freecad-wayland)
        ];

        custom.persist = {
          home = {
            directories = [
              ".config/FreeCAD"
              ".local/share/FreeCAD"
            ];
          };
        };
      })
    ]
  );
}
