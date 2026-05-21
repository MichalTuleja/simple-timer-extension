#!/bin/bash

UUID="simple-timer@michaltuleja.github.com"
EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
TARGET="$EXTENSIONS_DIR/$UUID"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Compile schemas
glib-compile-schemas "$SCRIPT_DIR/schemas/"

# Remove old installation
rm -rf "$TARGET"

# Symlink dev folder
ln -s "$SCRIPT_DIR" "$TARGET"

# Give GNOME Shell a moment to detect the new extension
sleep 1

# Launch nested GNOME Shell session with the extension enabled
echo "Starting nested GNOME Shell session..."
GNOME_SHELL_EXTENSIONS_ENABLED=1 MUTTER_DEBUG_DUMMY_MODE_SPECS=1366x768 dbus-run-session -- env UUID="$UUID" bash -c '
gsettings set org.gnome.shell disable-user-extensions false
gsettings set org.gnome.shell enabled-extensions "[\"$UUID\"]"
exec gnome-shell --nested --wayland
'
