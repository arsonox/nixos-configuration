{
  lib,
  fetchFromGitLab,
  mkKdeDerivation,
  kpackage,
  libplasma,
  qtwayland,
  qtdeclarative,
  qtbase,
}:

mkKdeDerivation {
  pname = "plasma-wallpaper-application";
  version = "unstable-2025-10-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "dos";
    repo = "plasma-wallpaper-application";
    rev = "eea391bb50e9e933e0f601dd432684bc0f9176e7";
    hash = "sha256-nZYJoyQ6NMnGJj06SvojPAS+HoMAhB9XsD683iRrztI=";
  };

  extraNativeBuildInputs = [
    kpackage
  ];

  extraBuildInputs = [
    libplasma
    qtwayland
    qtdeclarative
  ];

  extraCmakeFlags = [
    (lib.cmakeFeature "Qt6_DIR" "${qtbase}/lib/cmake/Qt6")
  ];

  meta = with lib; {
    description = "Set an arbitrary application as your Plasma wallpaper/screensaver";
    longDescription = ''
      This Plasma 6 wallpaper plugin allows you to use any application as a
      wallpaper or screensaver. It works by becoming a simple Wayland compositor
      that can accept a single fullscreen window from your chosen app.

      Examples include kweather, xscreensaver hacks via xwayland-run, Windows
      screensavers via Wine, or custom applications.
    '';
    homepage = "https://invent.kde.org/dos/plasma-wallpaper-application";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
