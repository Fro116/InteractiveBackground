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
class MonikaAfterStoryAdapter : ApplicationInterface {
    
    /**
     * Finds the Monika After Story window
     *
     * - returns: the first window named "Monika After Story", if one exists
     */
    private func getMASWindow() -> WindowInfo? {
        if m_window == nil {
            let windows = WindowInfo.getWindowList(listOptions: CGWindowListOption.optionAll)
            let matching = windows.filter({$0.name() == MonikaAfterStoryAdapter.WINDOW_NAME})
            m_window = matching.last
        }
        return m_window
    }
    
    /**
     * Sends a down keypress and an up keypress to the given process
     *
     * - parameter keyCode: the code of the key to press
     * - parameter pid: a process id
     */
    private static func simulateKeypress(keyCode: CGKeyCode, pid: Int32) {
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        keyDownEvent.postToPid(pid)
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!
        keyUpEvent.postToPid(pid)
    }
    
    /**
     * Sends a mouse event to the Monika After Story process
     *
     * - parameter the mouse click event
     */
    private func simulateMouseClick(event: NSEvent) {
        if let window = getMASWindow() {
            /**
             * Monika Afterstory does not respond to mouse events. It only responds
             * to special key events such as enter, backspace, and arrow keys.
             * We simulate a mouse click by pressing the enter button
             */
            let pid = window.pid()
            let enterCode = CGKeyCode(kVK_Return)
            MonikaAfterStoryAdapter.simulateKeypress(keyCode: enterCode, pid: pid)
        }
    }
    
    public func handle(event: NSEvent) {
        if event.type == NSEvent.EventType.leftMouseUp {
            simulateMouseClick(event: event)
        }
    }
    
    func image() -> NSImage? {
        return getMASWindow()?.image()
    }
    
    private static let WINDOW_NAME = "Monika After Story"
    private var m_window : WindowInfo? 
    
}
