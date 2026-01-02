{ pkgs, ... }:

{
  users.users.nox = {
    isNormalUser = true;
    description = "nox";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];
  };
}
