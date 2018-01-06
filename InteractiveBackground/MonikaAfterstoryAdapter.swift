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
class MonikaAfterstoryAdapter : ApplicationInterface {
    
    private func getMASWindow() -> WindowInfo? {
        if m_window == nil {
            let windows = WindowInfo.getWindowList(listOptions: CGWindowListOption.optionAll)
            let matching = windows.filter({$0.name() == MonikaAfterstoryAdapter.WINDOW_NAME})
            m_window = matching.last
        }
        return m_window
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
            if let window = getMASWindow() {
                MonikaAfterstoryAdapter.simulateMouseClick(window: window)
            }
        }
    }
    
    func image() -> NSImage? {
        return getMASWindow()?.image()
    }
    
    private static let WINDOW_NAME = "Monika After Story"
    private var m_window : WindowInfo? 
    
}
