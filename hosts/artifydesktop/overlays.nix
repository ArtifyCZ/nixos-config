{ ... }:

{
  nixpkgs.overlays = [
    # Override because nixpkgs unstable doesn't have the latest openttd-jgrpp version yet
    # (final: prev: {
    #   openttd-jgrpp = prev.openttd-jgrpp.overrideAttrs (old: {
    #     version = "0.72.1";
    #     src = prev.openttd-jgrpp.src.override {
    #       hash = "sha256-gPLObFbBvvr6iH9EG1lRDDFxB/8ccwc63ZgpiMVNAYg=";
    #     };
    #   });
    # })

    (
      final: prev:
      let
        inherit (final)
          stoat-desktop
          stdenv
          writeShellScriptBin
          ;
        name = "velotown-stoat";
        desktopName = "Velotown Stoat";
        stoatInstanceUrl = "https://chat.infestednetwork.com/";
        exec = "${stoat-desktop}/bin/stoat-desktop --force-server=\"${stoatInstanceUrl}\"";
        script = (writeShellScriptBin "${name}" "${exec} \$@");
        stoatDesktopEntry = builtins.elemAt stoat-desktop.desktopItems 0;
        desktopEntry = stoatDesktopEntry.override {
          inherit name desktopName exec;
        };
      in
      {
        "${name}" = stdenv.mkDerivation {
          inherit name;
          buildCommand = ''
            mkdir -p $out/bin
            cp ${script}/bin/${name} $out/bin/
            mkdir -p $out/share/applications
            cp ${desktopEntry}/share/applications/${name}.desktop $out/share/applications/
          '';
          dontBuild = true;
        };
      }
    )
  ];
}
