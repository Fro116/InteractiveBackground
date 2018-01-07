//
//  EventHandler.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Virtual layer to interact with an application
 */
protocol ApplicationInterface {    
    
    /**
     * Forwards a mouse or keyboard event to the given application
     *
     * - parameter event: a mouse or keyboard event
     */
    func handle(event: NSEvent)

    /**
     * Captures the viewing window of the application
     *
     * - returns: an image of the application's main window
     */
    func image() -> NSImage?
    
}
