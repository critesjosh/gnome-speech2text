#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error messages and exit
error_exit() {
    echo -e "${RED}Error:${NC} $1"
    # Clean up temporary directory if it exists
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    exit 1
}

# Function to print status messages
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo ""
echo -e "${GREEN}🎤 GNOME Speech2Text Extension Installer${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}⚡ Starting installation from local package...${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error_exit "Please don't run this script as root"
fi

print_status "Checking system requirements..."

# Check if GNOME Shell is installed
if ! command_exists gnome-shell; then
    error_exit "GNOME Shell is not installed"
fi

print_status "System requirements ✓"

# Create extensions directory if it doesn't exist
print_status "Setting up extension directory..."
EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXTENSIONS_DIR" || error_exit "Failed to create extensions directory"

# Check if extension is already installed
if [ -d "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page" ]; then
    echo -e "${YELLOW}Extension already installed. Updating...${NC}"
    rm -rf "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page" || error_exit "Failed to remove existing extension"
fi

# Verify we have all necessary files locally
print_status "Verifying package files..."
if [ ! -f "$PACKAGE_ROOT/extension.js" ]; then
    error_exit "extension.js not found in package"
fi
if [ ! -f "$PACKAGE_ROOT/metadata.json" ]; then
    error_exit "metadata.json not found in package"
fi
if [ ! -f "$SCRIPT_DIR/setup_env.sh" ]; then
    error_exit "setup_env.sh not found in package"
fi
if [ ! -f "$PACKAGE_ROOT/requirements.txt" ]; then
    error_exit "requirements.txt not found in package"
fi

# Create extension directory and copy files
print_status "Installing extension files..."
mkdir -p "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page" || error_exit "Failed to create extension directory"

# Copy all extension files from the package
if ! cp -r "$PACKAGE_ROOT"/* "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page/"; then
    error_exit "Failed to copy extension files"
fi

# Verify the extension was copied correctly
if [ ! -f "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page/metadata.json" ]; then
    error_exit "Extension was not copied correctly"
fi

# Make setup script executable
chmod +x "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page/scripts/setup_env.sh" || error_exit "Failed to make setup script executable"

# Run the setup script with progress information
echo ""
echo -e "${YELLOW}📦 Setting up Python environment and dependencies...${NC}"
echo -e "${YELLOW}⏱️  This may take 5-15 minutes depending on your internet speed${NC}"
echo -e "${YELLOW}💾 Downloading ~200-500MB (OpenAI Whisper + PyTorch)${NC}"
echo -e "${YELLOW}🔄 Please be patient - this is a one-time setup${NC}"
echo ""

cd "$EXTENSIONS_DIR/gnome-speech2text@kaveh.page" || error_exit "Failed to change to extension directory"
if ! bash scripts/setup_env.sh --progress; then
    error_exit "Setup script failed"
fi

# Return to previous directory
cd - > /dev/null || true

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Please restart GNOME Shell:${NC}"
echo -e "  - On X11: Press Alt+F2, type 'r' and press Enter"
echo -e "  - On Wayland: Log out and log back in"
echo -e "\n${GREEN}The extension should now be active in your top panel!${NC}" 