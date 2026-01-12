{
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    # package = pkgs.zed-editor.overrideAttrs (oldAttrs: {
    #   doCheck = false;
    # });
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
