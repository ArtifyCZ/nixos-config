{
  inputs,
  ...
}:

{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        # keep-sorted start case=no
        keep-sorted.enable = true;
        nixfmt.enable = true;
        # keep-sorted end
      };
    };
  };
}
