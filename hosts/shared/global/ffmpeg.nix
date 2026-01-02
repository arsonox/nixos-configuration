{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.ffmpeg-full.override {
      withUnfree = true;
    })
  ];
}
