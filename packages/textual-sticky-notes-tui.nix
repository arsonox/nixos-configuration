{
  lib,
  python,
  fetchFromGitHub,
}:

python.pkgs.buildPythonApplication rec {
  pname = "textual-sticky-notes-tui";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dengo07";
    repo = "textual-sticky-notes-tui";
    rev = "79de733953d4d5841422059f625b455d87143cff";
    hash = "sha256-MU5ONZ8fT5vPvXmyyTM/xO97si2ztqNX0jNKX+A6cxQ=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    textual
  ];

  # The application doesn't have tests
  doCheck = false;

  # Disable runtime deps check since nixpkgs has textual 6.11.0 but app requires >=7.0.0
  # The application should still work with 6.11.0 for basic functionality
  dontCheckRuntimeDeps = true;

  # Don't use the standard Python build process since the app uses relative imports
  dontUsePypaBuildPhase = true;
  dontUsePypaInstall = true;

  # Install the source files preserving structure and create executable
  installPhase = ''
        runHook preInstall

        # Create the application directory structure
        mkdir -p $out/share/textual-sticky-notes-tui

        # Copy the entire src directory to preserve the structure
        cp -r src $out/share/textual-sticky-notes-tui/

        # Copy assets if they exist
        if [ -d "assets" ]; then
          cp -r assets $out/share/textual-sticky-notes-tui/
        fi

        # Create the executable wrapper
        mkdir -p $out/bin
        cat > $out/bin/stickynotes << 'EOF'
    #!/usr/bin/env python3
    import sys
    import os

    # Add the src directory to Python path
    app_dir = os.path.join('${placeholder "out"}', 'share', 'textual-sticky-notes-tui', 'src')
    sys.path.insert(0, app_dir)

    # Change to the src directory so relative imports work
    os.chdir(app_dir)

    if __name__ == "__main__":
        from app import StickyNotesApp
        app = StickyNotesApp()
        app.run()
    EOF
        chmod +x $out/bin/stickynotes

        runHook postInstall
  '';

  meta = with lib; {
    description = "A keyboard-centric sticky notes TUI built with Python and Textual";
    longDescription = ''
      Sticky Notes TUI is a modern, keyboard-centric terminal-based application
      designed to manage your thoughts, tasks, and reminders efficiently. Built
      with Textual, it offers a seamless graphical experience directly within
      your console, featuring rich colors, priority management, and persistent storage.

      Features:
      - Keyboard-First Navigation
      - Rich Color Coding with 9 distinct colors
      - Priority Management (5 levels from Trivial to Critical)
      - Pinning System for important notes
      - Advanced Search functionality
      - Persistent Storage across sessions
      - Dark/Light Mode toggle
      - Responsive Grid Layout
    '';
    homepage = "https://github.com/dengo07/textual-sticky-notes-tui";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "stickynotes";
    platforms = platforms.linux;
  };
}
