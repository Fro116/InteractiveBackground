//
//  DesktopWindow.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/28/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Draws the desktop background
 */
class DesktopWindow : NSWindow {
    
    /**
     * Creates a full size window that overwrites the desktop
     */
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer _defer: Bool) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: _defer)
        
        // display this window above the desktop background and behind the desktop icons
        let desktopLevel = Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow))
        level = NSWindow.Level(desktopLevel)
    }
    
}
