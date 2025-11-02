//
//  SettingsView.swift
//  Blur
//
//  Created by Shubham Sharma
//  Email: shubhamsharma.emails@gmail.com
//  GitHub: https://github.com/Sharma-IT
//

import SwiftUI
import Carbon

struct SettingsView: View {
    @State private var isRecording = false
    @State private var currentKeyCode: UInt32
    @State private var currentModifiers: UInt32
    @State private var showSuccessMessage = false
    @State private var errorMessage: String?
    
    let onShortcutChanged: (UInt32, UInt32) -> Void
    
    init(onShortcutChanged: @escaping (UInt32, UInt32) -> Void) {
        self.onShortcutChanged = onShortcutChanged
        let prefs = ShortcutPreferences.shared
        _currentKeyCode = State(initialValue: prefs.keyCode)
        _currentModifiers = State(initialValue: prefs.modifiers)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.top, 20)

                Text("Blur Settings")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Customise your screen blur preferences")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 5)
            
            Divider()
            
            // Keyboard Shortcut Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Keyboard Shortcut")
                    .font(.headline)
                
                Text("Press the button below and then press your desired keyboard shortcut")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    ShortcutRecorderButton(
                        isRecording: $isRecording,
                        keyCode: currentKeyCode,
                        modifiers: currentModifiers,
                        onRecordingStarted: {
                            errorMessage = nil
                            showSuccessMessage = false
                        },
                        onShortcutRecorded: { keyCode, modifiers in
                            if validateShortcut(keyCode: keyCode, modifiers: modifiers) {
                                currentKeyCode = keyCode
                                currentModifiers = modifiers
                                saveShortcut()
                            }
                        }
                    )
                    
                    Spacer()
                    
                    Button("Reset to Default") {
                        resetToDefault()
                    }
                    .buttonStyle(.bordered)
                }
                
                // Success/Error Messages
                if showSuccessMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Shortcut saved successfully!")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .transition(.opacity)
                }
                
                if let error = errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .transition(.opacity)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Divider()
            
            // Information Section
            VStack(alignment: .leading, spacing: 8) {
                Text("How to Use")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 4) {
                    InfoRow(icon: "1.circle.fill", text: "Press your keyboard shortcut to blur the screen")
                    InfoRow(icon: "2.circle.fill", text: "Press the shortcut again or click anywhere to unblur")
                    InfoRow(icon: "3.circle.fill", text: "Access settings from the menu bar icon")
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
            Spacer(minLength: 10)

            // Footer
            VStack(spacing: 12) {
                Text("Blur requires Accessibility permissions to detect global shortcuts")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Text("Created by Shubham Sharma with 💙")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 16)
        }
        .padding()
        .frame(width: 500, height: 540)
    }
    
    private func validateShortcut(keyCode: UInt32, modifiers: UInt32) -> Bool {
        // Ensure at least one modifier is pressed
        if modifiers == 0 {
            errorMessage = "Please use at least one modifier key (⌘, ⌥, ⌃, or ⇧)"
            return false
        }
        
        // Check for system shortcuts (basic validation)
        let systemShortcuts: [(UInt32, UInt32)] = [
            (UInt32(kVK_ANSI_Q), UInt32(cmdKey)), // Cmd+Q
            (UInt32(kVK_ANSI_W), UInt32(cmdKey)), // Cmd+W
            (UInt32(kVK_ANSI_H), UInt32(cmdKey)), // Cmd+H
            (UInt32(kVK_Tab), UInt32(cmdKey)),    // Cmd+Tab
        ]
        
        for (sysKeyCode, sysModifiers) in systemShortcuts {
            if keyCode == sysKeyCode && modifiers == sysModifiers {
                errorMessage = "This shortcut conflicts with a system shortcut. Please choose another."
                return false
            }
        }
        
        return true
    }
    
    private func saveShortcut() {
        ShortcutPreferences.shared.saveShortcut(keyCode: currentKeyCode, modifiers: currentModifiers)
        onShortcutChanged(currentKeyCode, currentModifiers)
        
        withAnimation {
            showSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSuccessMessage = false
            }
        }
    }
    
    private func resetToDefault() {
        ShortcutPreferences.shared.resetToDefault()
        currentKeyCode = ShortcutPreferences.shared.keyCode
        currentModifiers = ShortcutPreferences.shared.modifiers
        onShortcutChanged(currentKeyCode, currentModifiers)
        
        withAnimation {
            showSuccessMessage = true
            errorMessage = nil
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(text)
                .font(.caption)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView { _, _ in }
    }
}

