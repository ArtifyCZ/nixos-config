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
  ];
}
