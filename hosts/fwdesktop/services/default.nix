{
  lib,
  pkgs,
  ...
}:

{
  # Import all packages from this directory
  imports = builtins.filter (lib.strings.hasSuffix ".nix") (
    map toString (builtins.filter (p: p != ./default.nix) (lib.filesystem.listFilesRecursive ./.))
  );

  environment.systemPackages = with pkgs; [
    framework-tool
    framework-tool-tui
  ];
}
