{
  lib,
  ...
}:

lib.warn "OpenLDAP tests are disabled through openldap.nix overlay!" {
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];
}
