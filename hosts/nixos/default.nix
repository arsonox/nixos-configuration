{
  ...
}:

{
  networking.hostName = "nixos";

  imports = [
    ./nixos-hw.nix
    ../shared
  ];
}
