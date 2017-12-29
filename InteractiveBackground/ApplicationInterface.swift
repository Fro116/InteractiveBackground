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
 *
 */
protocol ApplicationInterface {    
    
    /**
     * Forwards a mouse or keyboard event to the given application
     *
     * @param event a mouse or keyboard event
     */
    func handle(event: NSEvent)

    /**
     * Captures the viewing window of the application
     *
     * @return an image of the application's main window
     */
    func image() -> NSImage?
    
}
