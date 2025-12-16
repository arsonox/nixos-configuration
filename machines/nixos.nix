{ config, libs, pkgs, ... }:

{
  networking.hostName = "nixos";

  nix.settings.substitute = false;
  # system.includeBuildDependencies = true;

  # nix.settings.system-features = [
  #   "benchmark"
  #   "big-parallel"
  #   "nixos-test"
  #   "kvm"
  #   "gccarch-znver3"
  # ];
  
  # nixpkgs.hostPlatform = {
  #   gcc.arch = "znver3";
  #   gcc.tune = "znver3";
  #   system = "x86_64-linux";
  # };
 
  # nixpkgs.buildPlatform = {
  #   gcc.arch = "znver3";
  #   gcc.tune = "znver3";
  #   system = "x86_64-linux";
  # };

  imports = [
    ./nixos-hw.nix
    ../configuration.nix
  ];
}
