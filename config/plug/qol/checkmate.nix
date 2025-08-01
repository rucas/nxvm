{ pkgs, inputs, ... }:
{
  extraPlugins = [
    (pkgs.callPackage ../../../pkgs/checkmate.nix {
      inherit
        inputs
        ;
    })
  ];
}
