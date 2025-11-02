//
//  KeyboardShortcutManager.swift
//  Blur
//
//  Created by Shubham Sharma
//  Email: shubhamsharma.emails@gmail.com
//  GitHub: https://github.com/Sharma-IT
//

import Carbon
import Cocoa

class KeyboardShortcutManager {
    var onShortcutTriggered: (() -> Void)?
    private var eventHotKey: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    
    deinit {
        unregisterShortcut()
    }
    
    func registerShortcut(keyCode: UInt32, modifiers: UInt32) {
        // Unregister existing shortcut first
        unregisterShortcut()
        
        // Register new shortcut
        let hotKeyID = EventHotKeyID(signature: OSType(0x424C5552), id: 1) // 'BLUR'
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        // Install event handler
        InstallEventHandler(
            GetApplicationEventTarget(),
            { (nextHandler, theEvent, userData) -> OSStatus in
                guard let userData = userData else { return OSStatus(eventNotHandledErr) }
                
                let manager = Unmanaged<KeyboardShortcutManager>.fromOpaque(userData).takeUnretainedValue()
                manager.onShortcutTriggered?()
                
                return noErr
            },
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )
        
        // Register hot key
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &eventHotKey
        )
        
        if status != noErr {
            print("Failed to register hotkey: \(status)")
        }
    }
    
    func unregisterShortcut() {
        if let eventHotKey = eventHotKey {
            UnregisterEventHotKey(eventHotKey)
            self.eventHotKey = nil
        }
        
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
}

// MARK: - Key Code Utilities

extension KeyboardShortcutManager {
    static func carbonModifiersFromCocoaModifiers(_ modifiers: NSEvent.ModifierFlags) -> UInt32 {
        var carbonModifiers: UInt32 = 0
        
        if modifiers.contains(.command) {
            carbonModifiers |= UInt32(cmdKey)
        }
        if modifiers.contains(.shift) {
            carbonModifiers |= UInt32(shiftKey)
        }
        if modifiers.contains(.option) {
            carbonModifiers |= UInt32(optionKey)
        }
        if modifiers.contains(.control) {
            carbonModifiers |= UInt32(controlKey)
        }
        
        return carbonModifiers
    }
    
    static func cocoaModifiersFromCarbonModifiers(_ modifiers: UInt32) -> NSEvent.ModifierFlags {
        var cocoaModifiers: NSEvent.ModifierFlags = []
        
        if modifiers & UInt32(cmdKey) != 0 {
            cocoaModifiers.insert(.command)
        }
        if modifiers & UInt32(shiftKey) != 0 {
            cocoaModifiers.insert(.shift)
        }
        if modifiers & UInt32(optionKey) != 0 {
            cocoaModifiers.insert(.option)
        }
        if modifiers & UInt32(controlKey) != 0 {
            cocoaModifiers.insert(.control)
        }
        
        return cocoaModifiers
    }
}

