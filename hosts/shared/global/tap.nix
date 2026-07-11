{
  pkgs,
  ...
}:

{
  systemd.services.luak-net-taps = {
    description = "Persistent multiqueue tap loopback for hobby kernel network testing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ pkgs.iproute2 ];
    script = ''
      ip link show luakbr0   >/dev/null 2>&1 || ip link add luakbr0 type bridge
      ip link show luaktap0  >/dev/null 2>&1 || ip tuntap add dev luaktap0 mode tap user nox multi_queue
      ip link show luaktap1  >/dev/null 2>&1 || ip tuntap add dev luaktap1 mode tap user nox multi_queue
      ip link set luaktap0 master luakbr0
      ip link set luaktap1 master luakbr0
      ip link set luakbr0 up
      ip link set luaktap0 up
      ip link set luaktap1 up
    '';
  };
}
