//
//  BlurApp.swift
//  Blur
//
//  Created by Shubham Sharma
//  Email: shubhamsharma.emails@gmail.com
//  GitHub: https://github.com/Sharma-IT
//

import SwiftUI

@main
struct BlurApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var blurWindowManager: BlurWindowManager?
    var shortcutManager: KeyboardShortcutManager?
    var settingsWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide the app from the Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Initialise managers
        blurWindowManager = BlurWindowManager()
        shortcutManager = KeyboardShortcutManager()
        
        // Set up menu bar
        setupMenuBar()
        
        // Register keyboard shortcut
        setupKeyboardShortcut()
        
        // Check for accessibility permissions
        checkAccessibilityPermissions()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: "Blur")
            button.image?.isTemplate = true
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Toggle Blur", action: #selector(toggleBlur), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Blur", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    private func setupKeyboardShortcut() {
        shortcutManager?.onShortcutTriggered = { [weak self] in
            self?.toggleBlur()
        }
        
        // Load saved shortcut or use default
        let preferences = ShortcutPreferences.shared
        shortcutManager?.registerShortcut(
            keyCode: preferences.keyCode,
            modifiers: preferences.modifiers
        )
    }
    
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showPermissionAlert()
            }
        }
    }
    
    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Permission Required"
        alert.informativeText = "Blur needs accessibility permissions to detect global keyboard shortcuts. Please grant permission in System Preferences > Security & Privacy > Privacy > Accessibility."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Later")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    @objc private func toggleBlur() {
        blurWindowManager?.toggleBlur()
        updateMenuBarIcon()
    }
    
    private func updateMenuBarIcon() {
        if let button = statusItem?.button {
            let iconName = blurWindowManager?.isBlurActive == true ? "eye.fill" : "eye.slash.fill"
            button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Blur")
            button.image?.isTemplate = true
        }
    }
    
    @objc private func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView(
                onShortcutChanged: { [weak self] keyCode, modifiers in
                    self?.shortcutManager?.registerShortcut(keyCode: keyCode, modifiers: modifiers)
                }
            )
            
            let hostingController = NSHostingController(rootView: settingsView)
            let window = NSWindow(contentViewController: hostingController)
            window.title = "Blur Settings"
            window.styleMask = [.titled, .closable]
            window.setContentSize(NSSize(width: 500, height: 700))
            window.center()
            window.isReleasedWhenClosed = false
            
            settingsWindow = window
        }
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

