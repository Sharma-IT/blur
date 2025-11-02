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

        // If windows already exist, just bring them back and (re)attach handlers
        if !blurWindows.isEmpty {
            for window in blurWindows {
                if let blurWindow = window as? BlurWindow {
                    blurWindow.onMouseDown = { [weak self] in
                        self?.hideBlur()
                    }
                }
                window.orderFrontRegardless()
            }
            isBlurActive = true
            return
        }

        // Create blur window for each screen
        for screen in NSScreen.screens {
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

        // Set click handler
        window.onMouseDown = { [weak self] in
            self?.hideBlur()
        }

        // Create blur view sized to the window's content area (origin at 0,0)
        let blurView = createBlurView(frame: NSRect(origin: .zero, size: rect.size))
        window.contentView = blurView

        return window
    }
    
    private func createBlurView(frame: NSRect) -> NSView {
        let visualEffectView = NSVisualEffectView(frame: frame)
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.autoresizingMask = [.width, .height]

        // Add a subtle tint
        let tintView = NSView(frame: visualEffectView.bounds)
        tintView.wantsLayer = true
        tintView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.3).cgColor
        tintView.autoresizingMask = [.width, .height]

        visualEffectView.addSubview(tintView)

        // Add hint label
        let hintLabel = NSTextField(labelWithString: "Press shortcut again to unblur or click anywhere")
        hintLabel.font = .systemFont(ofSize: 16, weight: .medium)
        hintLabel.textColor = .white
        hintLabel.alignment = .center
        hintLabel.frame = NSRect(
            x: (frame.width - 400) / 2,
            y: frame.height / 2,
            width: 400,
            height: 30
        )
        hintLabel.autoresizingMask = [.minXMargin, .maxXMargin, .minYMargin, .maxYMargin]

        visualEffectView.addSubview(hintLabel)

        return visualEffectView
    }
}

// Custom window class to handle mouse events safely
class BlurWindow: NSWindow {
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

