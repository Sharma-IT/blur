//
//  ShortcutPreferences.swift
//  Blur
//
//  Created by Shubham Sharma
//  Email: shubhamsharma.emails@gmail.com
//  GitHub: https://github.com/Sharma-IT
//

import Carbon
import Foundation

class ShortcutPreferences {
    static let shared = ShortcutPreferences()

    private let keyCodeKey = "BlurKeyCode"
    private let modifiersKey = "BlurModifiers"

    // Default: Cmd+Shift+B
    private let defaultKeyCode: UInt32 = UInt32(kVK_ANSI_B)
    private let defaultModifiers: UInt32 = UInt32(cmdKey | shiftKey)

    var keyCode: UInt32 {
        get {
            let stored = UserDefaults.standard.integer(forKey: keyCodeKey)
            return stored == 0 ? defaultKeyCode : UInt32(stored)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: keyCodeKey)
        }
    }

    var modifiers: UInt32 {
        get {
            let stored = UserDefaults.standard.integer(forKey: modifiersKey)
            return stored == 0 ? defaultModifiers : UInt32(stored)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: modifiersKey)
        }
    }

    func saveShortcut(keyCode: UInt32, modifiers: UInt32) {
        self.keyCode = keyCode
        self.modifiers = modifiers
    }

    func resetToDefault() {
        UserDefaults.standard.removeObject(forKey: keyCodeKey)
        UserDefaults.standard.removeObject(forKey: modifiersKey)
    }
}



// Preferences for blurring behaviour (monitor selection)
final class BlurPreferences {
    static let shared = BlurPreferences()

    private let blurAllKey = "BlurAllMonitors"
    private let selectedIDsKey = "BlurSelectedDisplayIDs"

    // Default: blur all monitors
    var blurAllMonitors: Bool {
        get {
            if UserDefaults.standard.object(forKey: blurAllKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: blurAllKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: blurAllKey)
        }
    }

    // Stored as array of UInt32 (CGDirectDisplayID)
    var selectedDisplayIDs: [UInt32] {
        get {
            guard let arr = UserDefaults.standard.array(forKey: selectedIDsKey) as? [NSNumber] else {
                return []
            }
            return arr.map { UInt32(truncating: $0) }
        }
        set {
            let arr = newValue.map { NSNumber(value: $0) }
            UserDefaults.standard.set(arr, forKey: selectedIDsKey)
        }
    }
}
