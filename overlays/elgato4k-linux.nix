{
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      elgato4k-linux = final.callPackage ../packages/elgato4k-linux.nix { };
    })
  ];
}
