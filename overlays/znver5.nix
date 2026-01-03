{
  lib,
  config,
  ...
}:

let
  # which hosts we install this on
  enabledHosts = [
    "fwdesktop"
  ];
  enableApp = hostname: builtins.elem hostname enabledHosts;
in
{
  nixpkgs.overlays = lib.optionals (enableApp config.networking.hostName) [
    (
      self: super:
      let
        lib = super.lib;

        withZnver5 =
          pkg:
          pkg.overrideAttrs (
            old:
            let
              isX86 = super.stdenv.hostPlatform.isx86_64;
              flags = "-O3 -march=znver5 -mtune=znver5";
              existing = (old.env.NIX_CFLAGS_COMPILE or old.NIX_CFLAGS_COMPILE or "");
            in
            lib.optionalAttrs isX86 {
              env = (old.env or { }) // {
                NIX_CFLAGS_COMPILE = "${existing} ${flags}";
              };
            }
          );
      in
      {
        # firefox-unwrapped = withZnver5 super.firefox-unwrapped;

        ffmpeg-full = withZnver5 super.ffmpeg-full;
        # libvpx = withZnver5 super.libvpx;
        # x264 = withZnver5 super.x264;
        # x265 = withZnver5 super.x265;

        # jemalloc = withZnver5 super.jemalloc;
      }
    )
  ];
}
