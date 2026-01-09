{
  inputs,
  pkgs,
  ...
}:

let
  pkgs-zed = import inputs.nixpkgs-zed {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-zed.zed-editor;
    userSettings = {
      telemetry = {
        metrics = false;
      };
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
    };
    extensions = [
      "nix"
      "go-snippets"
      "toml"
      "make"
    ];
  };
}
