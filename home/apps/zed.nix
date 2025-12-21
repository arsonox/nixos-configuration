{ config, ... }:

{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      telemetry = {
        metrics = false;
      };
    };
    extensions = [
      "nix"
      "go-snippets"
    ];
  };
}
