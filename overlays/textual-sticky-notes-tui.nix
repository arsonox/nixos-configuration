{
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      textual-sticky-notes-tui =
        final.python3Packages.callPackage ../packages/textual-sticky-notes-tui.nix
          { };
    })
  ];
}
