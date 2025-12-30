{ pkgs, ... }:
{
  environment.systemPackage = [
    (pkgs.ffmpeg-full.override {
      withUnfree = true;
    })
  ];
}
