{
  lib,
  fetchFromGitHub,
  mkKdeDerivation,
  kpackage,
  libplasma,
  qtmultimedia,
  qtdeclarative,
  qtbase,
}:

mkKdeDerivation {
  pname = "plasma-smart-video-wallpaper-reborn";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-smart-video-wallpaper-reborn";
    rev = "v2.8.1";
    hash = "sha256-SpSKERzm4tKo5WvqNYiq/TfwSJY+oQWNQ93ENAA06Yc=";
  };

  extraNativeBuildInputs = [
    kpackage
  ];

  extraBuildInputs = [
    libplasma
    qtmultimedia
    qtdeclarative
  ];

  extraCmakeFlags = [
    (lib.cmakeFeature "Qt6_DIR" "${qtbase}/lib/cmake/Qt6")
  ];

  meta = with lib; {
    description = "KDE Plasma 6 wallpaper plugin to play videos on your Desktop/Lock Screen";
    longDescription = ''
      Smart Video Wallpaper Reborn is a Plasma 6 wallpaper plugin that allows
      you to play videos on your desktop or lock screen with advanced features:

      - Play single videos or slideshows
      - Enable/disable video sound with volume control
      - Lock screen support
      - Playback speed control and custom/random order
      - Cross-fade transitions between videos
      - Pause video based on conditions (maximized/fullscreen windows, active
        window, window presence, desktop effects, screen state)
      - Blur effects with configurable conditions
      - Battery mode with threshold support
    '';
    homepage = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
