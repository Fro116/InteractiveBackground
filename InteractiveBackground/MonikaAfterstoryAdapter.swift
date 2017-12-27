//
//  MonikaAfterstoryAdapter.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Simulates playing Monika Afterstory
 */
class MonikaAfterstoryAdapter : EventHandler {
    let WINDOW_NAME = "Monika After Story"
    
    public func handle(event: NSEvent) {
        // TODO switch to mirroring
        print(event)
        /*let listOptions = CGWindowListOption.optionAll
         let windowList = getWindowList(listOptions: listOptions)
         if let window = selectWindow(windowList: windowList, name: WINDOW_NAME) {
         // Simulate a mouse click in the MAS app. MAS does not recognize mouse click
         // events and only recognizes special key events suck as enter, escape, arrows,
         // and backspace
         let pid = window["kCGWindowOwnerPID"] as! Int32
         let enterCode = CGKeyCode(kVK_Return)
         AppDelegate.simulateKeypress(keyCode: enterCode, pid: pid)
         setDesktopBackground(window: window)
         }*/
    }
}
