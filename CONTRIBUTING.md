# Contributing to Blur

Thank you for your interest in contributing to Blur! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with the following information:

1. **Description**: Clear description of the bug
2. **Steps to Reproduce**: Detailed steps to reproduce the issue
3. **Expected Behaviour**: What you expected to happen
4. **Actual Behaviour**: What actually happened
5. **Environment**: 
   - macOS version
   - Blur version
   - Any relevant system configuration

### Suggesting Enhancements

Enhancement suggestions are welcome! Please create an issue with:

1. **Use Case**: Describe the problem you're trying to solve
2. **Proposed Solution**: Your suggested approach
3. **Alternatives**: Any alternative solutions you've considered
4. **Additional Context**: Screenshots, mockups, or examples

### Pull Requests

1. **Fork the Repository**: Create your own fork of the project
2. **Create a Branch**: Use a descriptive branch name
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Your Changes**: 
   - Follow the existing code style
   - Use British-English spelling
   - Add comments for complex logic
   - Update documentation if needed
4. **Test Your Changes**: Ensure the app builds and runs correctly
5. **Commit Your Changes**: Use clear, descriptive commit messages
   ```bash
   git commit -m "feat: add customisable blur intensity"
   ```
6. **Push to Your Fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**: Submit a PR with a clear description of your changes

## Development Guidelines

### Code Style

- Follow Swift API Design Guidelines
- Use clear, descriptive variable and function names
- Prefer explicit types for clarity
- Use `// MARK:` comments to organise code sections
- Keep functions focused and concise
- Use British-English spelling (e.g., "colour", "customise")

### Swift Conventions

```swift
// Good
func toggleBlur() {
    if isBlurActive {
        hideBlur()
    } else {
        showBlur()
    }
}

// Avoid
func toggle_blur() {  // Use camelCase, not snake_case
    // ...
}
```

### Comments

- Document the "why", not the "what"
- Use clear, concise language
- Add documentation comments for public APIs

```swift
// Good
// Registers a global keyboard shortcut using Carbon Event Manager
// This is necessary because NSEvent.addGlobalMonitorForEvents doesn't work for all key combinations
func registerShortcut(keyCode: UInt32, modifiers: UInt32) {
    // ...
}

// Avoid
// This function registers a shortcut
func registerShortcut(keyCode: UInt32, modifiers: UInt32) {
    // ...
}
```

### File Organisation

- Keep related functionality together
- Use extensions to organise code by functionality
- One class/struct per file (with exceptions for small helper types)

### Testing

While this project doesn't currently have automated tests, when adding new features:

1. Test on multiple macOS versions if possible
2. Test with multiple monitors
3. Test edge cases (e.g., no monitors, display changes)
4. Verify accessibility permissions handling

## Commit Message Guidelines

Use conventional commit format:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `perf:` Performance improvements
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add customisable blur intensity slider
fix: resolve multi-monitor blur coverage issue
docs: update README with new keyboard shortcuts
refactor: simplify window manager lifecycle
```

## Project Structure

When adding new files, follow the existing structure:

```
Blur/
├── Blur/
│   ├── Core/              # Core app logic (if adding new categories)
│   ├── UI/                # UI components (if adding new categories)
│   ├── Utilities/         # Helper utilities (if adding new categories)
│   └── Resources/         # Assets, plists, etc.
```

## Questions?

If you have questions about contributing, feel free to:

1. Open an issue with the "question" label
2. Reach out via email: shubhamsharma.emails@gmail.com

## Recognition

Contributors will be recognised in the project. Thank you for helping make Blur better!

