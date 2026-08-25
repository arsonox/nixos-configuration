{
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      ibkr-desktop = final.callPackage ../packages/ibkr-desktop.nix { };
    })
  ];
}
