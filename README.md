<p align="center">
  <p align="center">
   <img width="200" height="200" alt="blur_logo" src="https://github.com/user-attachments/assets/6afb2454-5ff1-4e13-a140-f6240c459904" />
  </p>
	<h1 align="center"><b>Blur</b></h1>
	<p align="center">
		macOS Screen Blur Application
  </p>
</p>
<br/>

A native macOS application that allows you to instantly blur your entire screen with a customisable keyboard shortcut. Perfect for privacy during screen sharing, presentations, or when you need to quickly hide sensitive information.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- **Global Keyboard Shortcuts**: Trigger blur from anywhere, even when the app is in the background
- **Multi-Monitor Support**: Blur all monitors or only selected displays (default: all)
- **Customisable Shortcuts**: Configure your preferred keyboard shortcut through an intuitive settings interface
- **Native macOS Blur**: Uses macOS's native visual effects for a polished, system-integrated look
- **Esc to Unblur**: Unblur using the shortcut again or press Esc on the focused blurred display (click-to-unblur removed)

- **Menu Bar Access**: Quick access to settings and controls from the menu bar
- **Persistent Preferences**: Your keyboard shortcut and monitor selection preferences are saved between app launches
- **Privacy-Focused**: No data collection, no network requests, completely offline

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)
- Accessibility permissions (required for global keyboard shortcuts)

## Installation

### Using the DMG Installer (Recommended)

1. **Download the latest release**:
   - Visit the [Releases page](https://github.com/Sharma-IT/blur/releases)
   - Download `Blur.dmg`

2. **Install the application**:
   - Open the downloaded `Blur.dmg` file
   - Drag `Blur.app` to the Applications folder
   - Eject the DMG

3. **Launch Blur**:
   - Open Blur from your Applications folder
   - You may need to right-click and select "Open" the first time (if not notarised)

4. **Grant Accessibility Permissions**:
   - On first launch, you'll be prompted to grant accessibility permissions
   - Go to System Preferences → Security & Privacy → Privacy → Accessibility
   - Add Blur to the list of allowed applications
   - Restart the app after granting permissions

### Building from Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sharma-IT/blur.git
   cd blur
   ```

2. **Open the project in Xcode**:
   ```bash
   open Blur.xcodeproj
   ```

3. **Build and run**:
   - Select the "Blur" scheme in Xcode
   - Press `Cmd+R` to build and run
   - Or use Product → Run from the menu

4. **Grant Accessibility Permissions** (same as above)

## Usage

### First Launch

1. Launch the Blur application
2. Grant accessibility permissions when prompted
3. The app will appear in your menu bar with an eye icon

### Basic Usage

1. **Activate Blur**: Press the keyboard shortcut (default: `Cmd+Shift+B`)
2. **Deactivate Blur**:
   - Press the same keyboard shortcut again, or
   - Press Esc on the blurred display

### Customising the Keyboard Shortcut

1. Click the Blur icon in the menu bar
2. Select "Settings..."
3. Click the shortcut recorder button
4. Press your desired key combination (must include at least one modifier key)
5. The shortcut is saved automatically

### Menu Bar Options

- **Toggle Blur**: Manually toggle the blur effect on/off
- **Settings...**: Open the settings window to customise the keyboard shortcut and monitor selection
- **Quit Blur**: Exit the application

## Default Keyboard Shortcut

The default keyboard shortcut is **`Cmd+Shift+B`** (⌘⇧B).

You can change this to any combination that includes at least one modifier key (⌘, ⌥, ⌃, or ⇧).

## Project Structure

```
Blur/
├── Blur.xcodeproj/          # Xcode project file
│   └── project.pbxproj      # Project configuration
├── Blur/                    # Source files
│   ├── BlurApp.swift        # Main app entry point and app delegate
│   ├── BlurWindowManager.swift       # Manages blur overlay windows
│   ├── KeyboardShortcutManager.swift # Global keyboard shortcut handling
│   ├── ShortcutPreferences.swift     # UserDefaults persistence
│   ├── SettingsView.swift            # SwiftUI settings interface
│   ├── ShortcutRecorderButton.swift  # Custom shortcut recorder UI
│   ├── Info.plist           # App metadata and configuration
│   └── Blur.entitlements    # App capabilities and permissions
└── README.md                # This file
```

## Architecture

### Core Components

1. **BlurApp**: Main application entry point using SwiftUI's `@main` attribute
2. **AppDelegate**: Manages app lifecycle, menu bar, and coordinates between components
3. **BlurWindowManager**: Creates and manages overlay windows with blur effects for each screen
4. **KeyboardShortcutManager**: Handles global keyboard shortcut registration using Carbon APIs
5. **ShortcutPreferences**: Manages persistent storage of user preferences
6. **SettingsView**: SwiftUI-based settings interface
7. **ShortcutRecorderButton**: Custom UI component for recording keyboard shortcuts

### Key Technologies

- **SwiftUI**: Modern declarative UI framework for the settings interface
- **AppKit**: Native macOS UI framework for window management and menu bar
- **Carbon Event Manager**: Low-level API for global keyboard shortcut detection
- **NSVisualEffectView**: Native macOS blur effect rendering
- **UserDefaults**: Persistent storage for user preferences

## Permissions

### Accessibility Permission

Blur requires accessibility permissions to detect global keyboard shortcuts. This is a macOS security feature that allows apps to monitor keyboard events system-wide.

**Why it's needed**: Without this permission, the app cannot detect keyboard shortcuts when it's not the active application.

**What it can access**: The app only monitors for the specific keyboard shortcut you've configured. It does not log keystrokes or access any other data.

## Troubleshooting

### Keyboard Shortcut Not Working

1. **Check Accessibility Permissions**:
   - Go to System Preferences → Security & Privacy → Privacy → Accessibility
   - Ensure Blur is in the list and checked
   - If it's already there, try removing and re-adding it

2. **Restart the App**: After granting permissions, restart Blur

3. **Check for Conflicts**: Your chosen shortcut might conflict with system shortcuts or other apps

### Blur Not Covering All Screens

- Ensure you're running macOS 13.0 or later
- Try toggling the blur off and on again
- Check if any screens are in a different Space or full-screen app

### Settings Window Not Appearing

- Click the menu bar icon and select "Settings..." again
- If the window is hidden, it might be on another Space or behind other windows
- Try quitting and relaunching the app

### Code Style

This project follows British-English spelling conventions and standard Swift coding practices:

- Use clear, descriptive variable and function names
- Follow Swift API Design Guidelines
- Use `// MARK:` comments to organise code sections
- Prefer explicit types for clarity

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## Privacy

Blur is completely privacy-focused:

- ✅ No data collection
- ✅ No analytics
- ✅ No network requests
- ✅ All preferences stored locally
- ✅ Open source - you can verify the code yourself

## Known Limitations

- Requires macOS 13.0 or later
- Requires accessibility permissions for global shortcuts
- Cannot blur above the login screen or system dialogs
- Some full-screen apps may prevent the blur overlay from appearing

## Future Enhancements

Potential features for future versions:

- [ ] Customisable blur intensity
- [ ] Different blur styles (light, dark, ultra-dark)
- [ ] Blur specific windows instead of entire screen
- [ ] Automatic blur when screen sharing is detected
- [ ] Touch Bar support
- [ ] Keyboard shortcut for temporary blur (hold to blur)

## License

This project is licensed under the MIT License - see below for details:

```
MIT License

Copyright (c) 2025 Shubham Sharma

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Author

**Shubham Sharma**
- GitHub: [@Sharma-IT](https://github.com/Sharma-IT)
- Email: shubhamsharma.emails@gmail.com

## Acknowledgements

- Built with Swift and SwiftUI
- Uses macOS native visual effects
- Inspired by the need for quick privacy during screen sharing

---

**Note**: This application is not affiliated with or endorsed by Apple Inc. macOS is a trademark of Apple Inc.

