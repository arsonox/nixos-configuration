{
  inputs,
  pkgs,
  ...
}:

{
  programs.codex = {
    enable = true;
    package = inputs.codex-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
