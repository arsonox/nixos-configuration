{
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      worldmonitor = final.callPackage ../packages/worldmonitor.nix { };
    })
  ];
}
