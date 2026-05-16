{ ... }:

{
  nixpkgs.overlays = [
    # Override because nixpkgs unstable doesn't have the latest openttd-jgrpp version yet
    (final: prev: {
      openttd-jgrpp = prev.openttd-jgrpp.overrideAttrs (old: {
        version = "0.72.2";
        src = prev.openttd-jgrpp.src.override {
          hash = "sha256-Ql3W+Xr5zXDW/IBY23X+RMSXieCqn35hYY3jfYGahgs=";
        };
      });
    })
  ];
}
