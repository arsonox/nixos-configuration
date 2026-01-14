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
    policies = {
      "firejail-default" = {
        # For now just complain instead of enforce. Firefox is broken with
        # enforce.
        # TODO: find out what is broken with Firefox and change to enforce.
        state = "complain";
        profile = ''
          include "${pkgs.firejail}/etc/apparmor.d/firejail-default"
        '';
      };
    };
  };
}
