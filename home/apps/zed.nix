{ ... }:

{
  programs.zed-editor = {
    enable = true;
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
