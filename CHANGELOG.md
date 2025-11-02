# Changelog

All notable changes to the Blur macOS application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-01

### Added
- Initial release of Blur for macOS
- Global keyboard shortcut support (default: Cmd+Shift+B)
- Multi-monitor blur support
- Customisable keyboard shortcuts through settings UI
- Menu bar interface with quick access to settings
- Persistent preferences using UserDefaults
- Accessibility permission handling and user guidance
- Native macOS blur effect using NSVisualEffectView
- Click-to-dismiss blur functionality
- Shortcut conflict validation
- Visual feedback for shortcut changes
- Comprehensive documentation (README, QUICKSTART, CONTRIBUTING)
- MIT License

### Technical Details
- Built with Swift 5.0 and SwiftUI
- Minimum macOS version: 13.0 (Ventura)
- Uses Carbon Event Manager for global keyboard shortcuts
- AppKit integration for window management
- No external dependencies

### Known Limitations
- Requires accessibility permissions for global shortcuts
- Cannot blur above login screen or system dialogs
- Some full-screen apps may prevent blur overlay

---

## Version History

### Version Numbering

This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

### Release Types

- **[Unreleased]**: Changes in development, not yet released
- **[X.Y.Z]**: Released versions with date

---

## How to Update This Changelog

When making changes, add entries under the `[Unreleased]` section in the appropriate category:

### Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

### Example Entry Format

```markdown
## [Unreleased]

### Added
- New blur intensity slider in settings
- Support for custom blur colours

### Fixed
- Resolved issue with multi-monitor blur coverage
- Fixed memory leak in window manager
```

When releasing a new version, move the `[Unreleased]` changes to a new version section with the release date.

---

[1.0.0]: https://github.com/Sharma-IT/blur/releases/tag/v1.0.0

