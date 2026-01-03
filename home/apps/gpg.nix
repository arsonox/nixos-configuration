{
  pkgs,
  ...
}:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
