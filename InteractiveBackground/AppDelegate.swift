//
//  AppDelegate.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/20/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

/*
 * Class to play an app as the desktop background
 */
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private static func simulateKeypress(keyCode: CGKeyCode, pid: Int32) {
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        keyDownEvent.postToPid(pid)
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!
        keyUpEvent.postToPid(pid)
    }
    
    private func isBackgroundEvent(event: NSEvent) -> Bool {
        // checks that all windows the point intersects with are below the background level
        let visibleLevel = CGWindowLevel(CGWindowLevelKey.baseWindow.rawValue)
        let backgroundLevel = CGWindowLevel(CGWindowLevelKey.desktopIconWindow.rawValue)
        let location = event.locationInWindow
        return Window.getWindowList(listOptions: CGWindowListOption.optionOnScreenOnly)
            .filter({$0.windowLevel()! >= visibleLevel})
            .filter({$0.bounds()?.contains(location) == true})
            .map({$0.windowLevel()! == backgroundLevel})
            .reduce(true, {$0 && $1})
    }

    private func handleEvent(event: NSEvent) -> Void {
        // forward events that interact with the desktop background
        if isBackgroundEvent(event: event) {
            handler.handle(event: event)
        }
    }
    
        
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mask : NSEvent.EventTypeMask = [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.leftMouseUp]
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handleEvent)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    private let handler : EventHandler = MonikaAfterstoryAdapter()
}

