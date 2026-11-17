{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags ? [ ],
}:

stdenv.mkDerivation {
  pname = "keychron-battery";
  version = "0.1.2-unstable-2026-09-23-${kernel.version}";

  # csutcliff/keychron-battery-dkms with PR #4 (which includes PR #3) applied:
  # M6 support, output-report requests, paired-mouse detection and charging
  # status. Switch back to upstream once it is merged.
  # https://github.com/csutcliff/keychron-battery-dkms/pull/4
  src = fetchFromGitHub {
    owner = "xdarklight";
    repo = "keychron-battery";
    rev = "283c9475599fa9e785c413a9c0a5b69f1218223a";
    hash = "sha256-6YZ17GwAPuNyHqc04EbYrkRUlYtjnpF5IOyhwYMJFlk=";
  };

  # Local, not yet upstreamed: G6 HE via the TurboLink 8K receiver (3434:d05a),
  # which has the vendor protocol on interface 1 instead of 4.
  patches = [ ./g6-he-turbolink.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/hid"
    "DEPMOD=true"
  ];

  # Upstream's Makefile has no install target; use kbuild's modules_install,
  # which signs the module and writes the .ko.cer that aggregateModules needs.
  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
  installTargets = [ "modules_install" ];

  meta = {
    description = "Kernel module exposing Keychron mouse battery via power_supply";
    homepage = "https://github.com/csutcliff/keychron-battery-dkms";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
