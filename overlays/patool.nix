{
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      python314Packages = prev.python314Packages.overrideScope (
        pyFinal: pyPrev: {
          patool = pyPrev.patool.override {
            file = prev.file.overrideAttrs {
              # Work around too strict landlock hardening
              # https://bugs.astron.com/view.php?id=785
              postPatch = ''
                substituteInPlace src/landlock.c --replace-fail \
                  "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR" \
                  "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_EXECUTE"
              '';
            };
          };
        }
      );
    })
  ];
}
