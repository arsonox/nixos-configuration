{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      plasma-smart-video-wallpaper-reborn =
        final.kdePackages.callPackage ../packages/plasma-smart-video-wallpaper-reborn.nix
          { };
    })
  ];
}
