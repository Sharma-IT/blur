//
//  BlurWindowManager.swift
//  Blur
//
//  Created by Shubham Sharma
//  Email: shubhamsharma.emails@gmail.com
//  GitHub: https://github.com/Sharma-IT
//

import Cocoa
import SwiftUI
import Carbon


class BlurWindowManager {
    private var blurWindows: [NSWindow] = []
    private(set) var isBlurActive = false
    private var isHiding = false

    func toggleBlur() {
        if isBlurActive {
            hideBlur()
        } else {
            showBlur()
        }
    }

    func showBlur() {
        guard !isBlurActive else { return }

        // If windows already exist, just bring them back to front
        if !blurWindows.isEmpty {
            for window in blurWindows {
                window.orderFrontRegardless()
            }
            isBlurActive = true
            return
        }

        // Create blur window for target screens based on preferences
        for screen in targetScreens() {
            let window = createBlurWindow(for: screen)
            blurWindows.append(window)
            window.orderFrontRegardless()
        }

        isBlurActive = true
    }

    func hideBlur() {
        guard isBlurActive && !isHiding else { return }

        isBlurActive = false
        isHiding = true


        // Defer window cleanup to avoid closing windows during event handling
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            for window in self.blurWindows {
                window.orderOut(nil)
            }

            self.isHiding = false
        }
    }
    private func targetScreens() -> [NSScreen] {
        let prefs = BlurPreferences.shared
        let screens = NSScreen.screens
        if prefs.blurAllMonitors { return screens }
        let selected = Set(prefs.selectedDisplayIDs)
        if selected.isEmpty { return [] }
        return screens.compactMap { screen in
            if let id = displayID(for: screen) {
                return selected.contains(id) ? screen : nil
            }
            return nil
        }
    }

    private func displayID(for screen: NSScreen) -> UInt32? {
        let key = NSDeviceDescriptionKey("NSScreenNumber")
        if let number = screen.deviceDescription[key] as? NSNumber {
            return number.uint32Value
        }
        return nil
    }


    private func createBlurWindow(for screen: NSScreen) -> NSWindow {
        // Use global coordinates for the window frame to precisely cover each display
        let rect = screen.frame
        let window = BlurWindow(
            contentRect: rect,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.setFrame(rect, display: false)

        // Configure window properties
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.animationBehavior = .none // Disable implicit window close/transform animations
        window.ignoresMouseEvents = false
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

        // Clicking on the overlay should focus it; unblurring is handled via Esc/shortcut

        // Create blur view sized to the window's content area (origin at 0,0)
        let blurView = createBlurView(frame: NSRect(origin: .zero, size: rect.size))
        window.contentView = blurView

        return window
    }

    private func createBlurView(frame: NSRect) -> NSView {
        // Content view that handles focus and Esc key
        let content = BlurContentView(frame: frame)
        content.autoresizingMask = [.width, .height]
        content.onEscape = { [weak self] in
            self?.hideBlur()
        }

        // Visual effect background
        let visualEffectView = NSVisualEffectView(frame: content.bounds)
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.autoresizingMask = [.width, .height]
        content.addSubview(visualEffectView)

        // Subtle tint overlay
        let tintView = NSView(frame: visualEffectView.bounds)
        tintView.wantsLayer = true
        tintView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.3).cgColor
        tintView.autoresizingMask = [.width, .height]
        visualEffectView.addSubview(tintView)

        // Hint label
        let hintLabel = NSTextField(labelWithString: "Press shortcut again or press Esc to unblur")
        hintLabel.font = .systemFont(ofSize: 16, weight: .medium)
        hintLabel.textColor = .white
        hintLabel.alignment = .center
        hintLabel.frame = NSRect(
            x: (frame.width - 420) / 2,
            y: frame.height / 2,
            width: 420,
            height: 30
        )
        hintLabel.autoresizingMask = [.minXMargin, .maxXMargin, .minYMargin, .maxYMargin]
        visualEffectView.addSubview(hintLabel)

        return content
    }
}

// Custom window class to handle mouse events safely
class BlurWindow: NSWindow {
    override var canBecomeKey: Bool { true }

    var onMouseDown: (() -> Void)?

    override func mouseDown(with event: NSEvent) {
        // Only call if callback is still set (prevents calling during cleanup)
        guard let callback = onMouseDown else { return }

        // Call on next run loop to avoid closing window during event handling
        DispatchQueue.main.async {
            callback()
        }
    }
}


// Content view that accepts focus and handles Esc to unblur
class BlurContentView: NSView {
    var onEscape: (() -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window?.isKeyWindow == true {
            window?.makeFirstResponder(self)
        }
    }

    override func mouseDown(with event: NSEvent) {
        // Focus the overlay on click; do not unblur on click
        window?.makeKeyAndOrderFront(nil)
        window?.makeFirstResponder(self)
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == UInt16(kVK_Escape) {
            DispatchQueue.main.async { [weak self] in
                self?.onEscape?()
            }
        } else {
            super.keyDown(with: event)
        }
    }
}

