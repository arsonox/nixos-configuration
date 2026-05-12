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
      ensure_final_newline_on_save = false;
      theme = {
        mode = "dark";
        dark = "One Dark";
        light = "One Light";
      };
      icon_theme = {
        mode = "dark";
        dark = "Zed (Default)";
        light = "Zed (Default)";
      };
    };
    extensions = [
      "nix"
      "go-snippets"
      "toml"
      "make"
      "assembly"
      "zig"
      "lua"
    ];
  };
}
