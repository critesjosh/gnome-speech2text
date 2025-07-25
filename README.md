# GNOME Speech2Text

🚧 Work in Progress - I've tested extensively on Ubuntu 24.04 / GNOME 46 / x11. Wayland should be working, but it's a lot more finicky at the moment. Happy to address any issues you might encounter. 🚧

A GNOME Shell extension that adds speech-to-text functionality using
[OpenAI's Whisper](https://github.com/openai/whisper) model. Speak into your microphone
and have your words automatically typed wherever your cursor is.

I wrote this extension to mostly use with Cursor AI since speaking is much faster than typing. I'm on Ubuntu 24.04 and
GNOME Shell 46, and unfortunately couldn't find any existing extensions that did this, so I built this over a weekend half
vibe-learning GNOME extensions and half vice-coding the actual script.

![recording-modal](./images/recording-modal.png)

## Features

- 🎤 **Real-time Speech Recognition** using OpenAI Whisper
- ⌨️ **Automatic Text Insertion** at cursor location
- 🖱️ **Click to Record** from top panel microphone icon
- ⌨️ **Keyboard Shortcut** support (default: Ctrl+Shift+Alt+C)
- 🌍 **Multi-language Support** (depending on Whisper model)
- ⚙️ **Easy Configuration** through settings panel

## Wayland Limitation: Inserting Preview Text

**Note:** Due to technical limitations in GNOME Shell and the Wayland display server, the extension cannot programmatically "type" or insert the preview text into applications when running on Wayland. This is a security and sandboxing feature of Wayland, which does not allow extensions to simulate keyboard input for other apps.

- On **X11** (the traditional Linux display server), the extension can insert the preview text at your cursor position in any application. The **Insert** button will be shown in the preview dialog.
- On **Wayland**, this is not possible. The **Insert** button will be hidden, and you can only use the **Copy** button to copy the transcribed text to your clipboard, then paste it manually where you want.

**Logic in the Extension:**

- The extension detects at load time whether it is running on Wayland or X11.
- If on X11, the Insert button is shown and works as expected.
- If on Wayland, the Insert button is hidden to avoid user confusion, since insertion is not possible.

This ensures the extension provides the best possible user experience on both display servers, and avoids showing non-functional UI on Wayland.

## Requirements

- GNOME Shell 46 or later
- Python 3.8 or later
- FFmpeg
- xdotool

## System Requirements Installation

Before installing the extension, make sure you have the required system packages:

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv ffmpeg xdotool libglib2.0-dev
```

I have only tested this on Ubuntu 24.04, but it should work on any GNOME Shell 46+ distribution with the above packages installed.

## Installation

### Option 1: One-Line Install (Recommended)

Run this single command to download and install everything automatically:

```bash
wget -qO- https://raw.githubusercontent.com/kavehtehrani/gnome-speech2text/main/scripts/install.sh | bash
```

**⏱️ Note: First-time installation takes 5-15 minutes** as it downloads and installs:

- OpenAI Whisper (~200-500MB)
- PyTorch and ML dependencies
- Python virtual environment

The script will show progress messages. Please be patient!

Then restart GNOME Shell:

- **X11**: Press Alt+F2, type 'r', press Enter
- **Wayland**: Log out and log back in (note Wayland support is not yet implemented)

### Option 2: From Local Repository

If you prefer to clone the repository first:

```bash
git clone https://github.com/kavehtehrani/gnome-speech2text.git
cd gnome-speech2text
./scripts/install.sh
```

### Option 3: GNOME Extensions Website

[Pending Approval]

## First-Time Setup

When you first enable the extension, if the Python environment isn't set up:

1. **Automatic Setup**: A terminal window will open automatically
2. **Interactive Prompts**: Follow the on-screen instructions
3. **Progress Visibility**: Watch the installation progress in real-time
4. **Completion**: Terminal will show success message and next steps

## Usage

### Quick Start

1. **Click** the microphone icon in the top panel, or
2. **Press** the keyboard shortcut (default: Ctrl+Shift+Alt+C)
3. **Speak** when the recording dialog appears
4. **Press Enter** to process and insert text, or **Escape** to cancel

### Settings

Right-click the microphone icon → Settings to configure:

- Keyboard shortcuts
- Troubleshooting tools
- Manual Python environment reinstall

## Troubleshooting

### Extension Not Working?

1. First make sure the extension is enabled in GNOME Tweaks or Extensions app and has no error message.
2. Right-click microphone icon → Settings
3. Click "Install/Reinstall Python Environment"
4. Follow terminal prompts to reinstall

You can always read the logs in the terminal or journal to see if there are any errors by running:
`journalctl /usr/bin/gnome-shell -f`

## Privacy & Security

🔒 **100% Local Processing** - All speech recognition happens on your local machine. Nothing is ever sent to the cloud or external servers. While this extension uses OpenAI's Whisper model, it runs the open-source version locally on your computer, ensuring privacy of your voice data.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

### Reporting Issues

Please include:

- GNOME Shell version
- Operating system
- Error logs from terminal or journal
- Steps to reproduce

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
