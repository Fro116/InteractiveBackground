//
//  MonikaAfterstoryAdapter.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa
import Carbon.HIToolbox


/**
 * Simulates playing Monika Afterstory
 */
class MonikaAfterstoryAdapter : EventHandler {
    
    private static let WINDOW_NAME = "Monika After Story"
    
    private static func getMASWindow() -> WindowInfo? {
        let windows = WindowInfo.getWindowList(listOptions: CGWindowListOption.optionAll)
        let matching = windows.filter({$0.name() == WINDOW_NAME})
        return matching.last
    }
    
    private static func simulateKeypress(keyCode: CGKeyCode, pid: Int32) {
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        keyDownEvent.postToPid(pid)
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!
        keyUpEvent.postToPid(pid)
    }
    
    private static func simulateMouseClick(window: WindowInfo) {
        /**
         * Monika Afterstory does not respond to mouse events. It responds
         * to special key events such as enter, backspace, and arrow keys.
         * We simulate a mouse click by pressing the enter button
         */
        let pid = window.pid()
        let enterCode = CGKeyCode(kVK_Return)
        simulateKeypress(keyCode: enterCode, pid: pid)
    }
    
    public func handle(event: NSEvent) {
        if event.type == NSEvent.EventType.leftMouseUp {
            if let window = MonikaAfterstoryAdapter.getMASWindow() {
                MonikaAfterstoryAdapter.simulateMouseClick(window: window)
                DesktopBackground.set(window: window)
            }
        }
    }
}
