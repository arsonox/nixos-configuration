{
  lib,
  ...
}:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nerp" ];
    authentication = lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
}