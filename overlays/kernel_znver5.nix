{
  boot.kernelPackages =
    let
      pkgs = import <nixpkgs> { };
    in
    pkgs.linuxPackagesFor (
      pkgs.linux.override {
        extraMakeFlags = [
          "KCFLAGS=-O3 -march=znver5 -mtune=znver5"
          "KCPPFLAGS=-march=znver5 -mtune=znver5"
        ];
      }
    );
}
