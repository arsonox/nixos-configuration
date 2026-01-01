{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      plasma-wallpaper-application =
        final.kdePackages.callPackage ../packages/plasma-wallpaper-application.nix
          { };
    })
  ];
}
