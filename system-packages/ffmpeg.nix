{ pkgs, ... }:
{
<<<<<<< HEAD
  environment.systemPackages = [
=======
  environment.systemPackage = [
>>>>>>> refs/remotes/origin/main
    (pkgs.ffmpeg-full.override {
      withUnfree = true;
    })
  ];
}
