{
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      tibia = final.callPackage ../packages/tibia.nix { };
    })
  ];
}
