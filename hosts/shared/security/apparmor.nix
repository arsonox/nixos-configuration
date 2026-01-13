{
  pkgs,
  ...
}:

{
  security.apparmor = {
    enable = true;
    packages = with pkgs; [
      apparmor-profiles
      apparmor-utils
      firejail
    ];
  };
}
