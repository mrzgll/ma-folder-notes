# MA Folder Notes - Lightroom Classic Plugin

This Lightroom plugin allows you to associate plain-text notes with folders.
Each note is stored as a `.txt` file in a folder of your choice.

The note filename is automatically generated from the folder name, using
preconfigured patterns supporting workflow's naming conventions.

Launching the plugin when a folder is selected automatically opens the note file
with a preconfigured text editor.

**Important notice: This plugin has been tested only on Windows.**

## Installation

1. Download or clone this plugin.
2. Place the `folder_notes.lrdevplugin` folder wherever you prefer.
3. In Lightroom Classic, open the Plug-in Manager, then add and enable the plugin.

## Configuration

Before using the plugin, it shall be configured in the Lightroom Classic Plug-in Manager.

### 1. Note File Patterns configuration

The name of the note file is built from the name of the folder, with the assumption that each folder name
contains a unique string acting as folder identifier (FID).

Up to two Lua patterns shall be defined, to extract the FID from the folder name and build the
note file name from it. Each pattern must capture the complete FID in a single group; the note file
is named `<FID>.txt`.

Pattern 1 is tried first; pattern 2 is tried only if pattern 1 does not capture any FID.
These two patterns can be used to match folder names complying two different naming conventions, e.g. for native
digital photos and digitized analog photos.

For more info on Lua pattern matching visit: https://gist.github.com/spr2-dev/46ca9f4a6f933fa266bccd87fd15d09a

Examples:

- **Pattern 1**
  - Native digital photos:     `^(%d%d%d%d[-_]%d%d[-_]%d%d[-_]%w+)` matches a folder such as `2024-12-15-A7II-Cagliari` or `2025_01_05_Df_Pisa`.
    Here the FID contains the capture date and the camera id. The note files will be named respectively `2024-12-15-A7II.txt` and `2025_01_05_Df.txt`.

- **Pattern 2**
  - Digitized analog photos: `^(%w+%-%d%d%d%d%w*)%-%d%d%d%d` matches a folder such as `s-0128-1999` or `s-0130b-2000` or `bm-0095-2001`.
  Here the FID contains the roll ID. The note files will be named respectively `s-0128.txt`, `s-0130b.txt` and `bm-0095.txt`.

Only the captured parts of the folder name are used to form the note filename. This means you can change the folder name without breaking its association with the note file, as long as the folder identifier remains the same.

### 2. File System Paths

- **Notes folder path**: Directory where note files will be stored. Use a folder that is always  available and add it to your backup procedure

- **Notes editor path**: Path to your preferred text editor.

- **Editor options**: Optional command-line options passed to the editor before the note path, e.g. `-nosession` for Notepad++. Leave it empty for editors that do not need options (for example Notepad, which does not accept `-nosession`).

## Usage

1. In Lightroom Classic's Library module, select a folder.
2. Go to **Library → Plug-in Extras → Open folder notes**.
3. The file is opened in the configured editor (it the file does not exist, the editor shall create it).
4. When you are done editing, save your notes.

## Troubleshooting

**"Cannot determine note filename" error**
- Verify that the folder name matches one of the configured Lua patterns.
- Check the pattern syntax in the Plug-in Manager settings.
- Try a simple pattern first, such as `(.*)`, to match any folder name.

**The notes editor does not open**
- Confirm that the editor path is correct in the Plug-in Manager settings.
- Ensure that the editor executable exists at the specified path.
- On Windows, try using the full path, including the `.exe` extension.

## Disclaimer

This is an independent, hobby project and is not affiliated with, endorsed
by, or supported by Adobe. "Lightroom Classic" and "LrC" are used here only
to describe compatibility.

This plugin is provided as is, with no warranty of any kind. It opens
plain-text `.txt` files and launches an external editor process; it
does not read or write any photo metadata. Even so, behavior may vary
depending on your operating system, editor of choice, and folder naming
conventions, so it is worth testing your configured patterns on a few
folders before relying on it across your full catalog.

This plugin has been tested on Lightroom Classic 14 and later versions.
Tests have been carried out only on Windows 11. There is no guarantee
that this plugin works on macOS or previous versions of Windows.

This project is maintained on a best effort basis in my spare time. Bug
reports and feature requests are welcome, but there is no guarantee of a
timeline for fixes or new features.

## License

See the `LICENSE` file for details.

## Support

For issues or feature requests, please visit the project repository.
