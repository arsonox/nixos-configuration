{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_GB-ise
    hunspellDicts.nl_NL
  ];
}
