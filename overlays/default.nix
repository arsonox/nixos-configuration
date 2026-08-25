{
  ...
}:

{
  imports = [
    ./claude-code.nix
    ./znver5.nix
    ./plasma-wallpaper-application.nix
    ./textual-sticky-notes-tui.nix
    ./elgato4k-linux.nix
    ./tibia.nix
    ./ibkr-desktop.nix

    #i686 openldap tests are broken so for now just ignore
    #./openldap.nix
  ];
}
