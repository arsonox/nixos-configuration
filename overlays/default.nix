{
  ...
}:

{
  imports = [
    ./claude-code.nix
    ./znver5.nix
    ./plasma-wallpaper-application.nix
    # ./plasma-smart-video-wallpaper-reborn.nix
    ./textual-sticky-notes-tui.nix
    # ./worldmonitor.nix
    ./elgato4k-linux.nix
    ./tibia.nix

    #i686 openldap tests are broken so for now just ignore
    #./openldap.nix
  ];
}
