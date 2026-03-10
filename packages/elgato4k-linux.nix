{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libusb1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elgato4k-linux";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "13bm";
    repo = "elgato4k-linux";
    rev = "f654c66ad4b14eb3537d9469d3f128e8f69caf10";
    hash = "sha256-FBME40JCZ/Vrgu2Wc311mmClkJFKDvkjerhvuuy2tO4=";
  };

  cargoHash = "sha256-tHZKPZqivmlgVonLd0ZItVAufxjuRtS66OAwYTwCv+g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  postInstall = ''
    install -Dm644 -t $out/lib/udev/rules.d/ ${finalAttrs.passthru.udevRules}
  '';

  passthru.udevRules = builtins.toFile "99-elgato-capture.rules" ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009b", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009c", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009d", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="00af", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="00ae", MODE="0666", GROUP="plugdev"
  '';

  meta = {
    description = "Unofficial Linux control utility for Elgato 4K capture cards";
    homepage = "https://github.com/13bm/elgato4k-linux";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "elgato4k-linux";
  };
})
