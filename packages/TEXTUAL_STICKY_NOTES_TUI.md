# Textual Sticky Notes TUI

A keyboard-centric sticky notes TUI (Terminal User Interface) built with Python and Textual.

## Package Information

- **Package Name**: `textual-sticky-notes-tui`
- **Version**: 0.1.0
- **Upstream**: https://github.com/dengo07/textual-sticky-notes-tui
- **License**: MIT
- **Executable**: `stickynotes`

## Description

Sticky Notes TUI is a modern, keyboard-centric terminal-based application designed to manage your thoughts, tasks, and reminders efficiently. Built with Textual, it offers a seamless graphical experience directly within your console, featuring rich colors, priority management, and persistent storage.

## Features

- **Keyboard-First Navigation**: Navigate, create, edit, and delete notes without ever leaving your keyboard
- **Rich Color Coding**: Organize notes visually using 9 distinct colors with simple hotkeys
- **Priority Management**: Assign 5 levels of priority (from Trivial to Critical) with visual indicators
- **Pinning System**: Pin important notes to keep them highlighted and distinguished
- **Advanced Search**: Filter notes instantly by title, content, or tags via a dedicated modal
- **Persistent Storage**: Automatically saves your notes to your OS-specific application data directory
- **Dark/Light Mode**: Toggle between themes to suit your environment
- **Responsive Layout**: Grid layout automatically adjusts columns based on your terminal width

## Installation

This package is added to your NixOS configuration through:

1. Package definition: `packages/textual-sticky-notes-tui.nix`
2. Overlay: `overlays/textual-sticky-notes-tui.nix`
3. Home-manager configuration: `home/apps/textual-sticky-notes-tui.nix`

The package is automatically available after rebuilding your system.

## Usage

Launch the application by running:

```bash
stickynotes
```

### Keybindings

#### Global Controls

| Key | Action | Description |
|-----|--------|-------------|
| `a` | Add Note | Create a new sticky note |
| `e` | Edit Note | Edit the content, title, priority, or pin status of the focused note |
| `r` | Remove Note | Delete the currently focused note (triggers a confirmation modal) |
| `s` | Search | Open the search modal to find specific notes |
| `o` | Sort | Sort notes automatically (Pinned first, then by Priority) |
| `d` | Toggle Theme | Switch between Dark and Light mode |
| `Ctrl+s` | Save | Manually force save to disk |
| `Ctrl+c` | Quit | Force quit the application |

#### Navigation

| Key | Action |
|-----|--------|
| Arrow Keys or `h-j-k-l` | Move focus between notes |
| `Tab` | Move focus between parts inside a modal |

#### Styling (When a note is focused)

| Key | Action |
|-----|--------|
| `1` - `9` | Change the border color of the selected note |

## Priority Levels

- **Trivial** (Default)
- **Low**
- **Medium**
- **High**
- **Critical**

Notes display visual icons corresponding to their priority level and pin status.

## Data Storage

The application uses an intelligent storage system that respects your operating system's standards:

- **Linux**: `~/.local/share/sticky-notes/notes.json` (XDG Base Directory)
- **macOS**: `~/Library/Application Support/StickyNotes/notes.json`
- **Windows**: `%APPDATA%\StickyNotes\notes.json`

The data is saved in a human-readable JSON format, allowing for easy backup or manual inspection if necessary.

## Technical Details

### Dependencies

- Python 3.13+
- textual >= 6.11.0

**Note**: The upstream project requires textual >= 7.0.0, but this package has been configured to work with textual 6.11.0 available in nixpkgs. Basic functionality should work correctly, though some newer features may be unavailable.

### Package Structure

The package:
1. Fetches the source from GitHub
2. Builds using Python's setuptools
3. Installs the application modules to the Python site-packages
4. Creates a wrapper script `stickynotes` in `/bin`

### Build Configuration

- `dontCheckRuntimeDeps = true`: Disabled to allow using textual 6.11.0 instead of the required 7.0.0
- `doCheck = false`: The upstream application doesn't include tests

## Troubleshooting

### Application won't start

Ensure your terminal emulator supports TrueColor. Most modern terminal emulators (kitty, alacritty, iTerm2, Windows Terminal) support this by default.

### Notes not saving

Check that you have write permissions to the data directory:
```bash
ls -la ~/.local/share/sticky-notes/
```

### Version incompatibility

If you encounter issues due to the textual version difference, you can try:
1. Reporting the issue to ensure compatibility
2. Waiting for nixpkgs to update to textual >= 7.0.0
3. Using a custom textual overlay to install version 7.0.0+

## Maintenance

### Updating the Package

To update to a newer version:

1. Check for new releases: https://github.com/dengo07/textual-sticky-notes-tui/commits/master
2. Update the `rev` in `packages/textual-sticky-notes-tui.nix`
3. Get the new hash:
   ```bash
   nix-prefetch-url --unpack https://github.com/dengo07/textual-sticky-notes-tui/archive/<NEW_COMMIT>.tar.gz
   nix hash to-sri --type sha256 <HASH>
   ```
4. Update the `hash` field with the SRI hash
5. Rebuild and test

## Related Links

- [GitHub Repository](https://github.com/dengo07/textual-sticky-notes-tui)
- [Textual Framework](https://textual.textualize.io/)