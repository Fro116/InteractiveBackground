//
//  DesktopBackground.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Class to handle setting the desktop background
 */
class DesktopBackground {
    
    /* The desktop image will be cached if we try to reuse image names.
     * To force the desktop image to refresh, each background image is
     * given a different name */
    private static var forceDesktopImageRefreshID = 0
    
    public static func set(imageURL: URL) {
        // sets the background on the current space of each monitor
        let screens = NSScreen.screens
        for screen in screens {
            try! NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
        }
    }
    
    public static func set(window: WindowInfo) {
        // clean up last image
        let oldURL = generateImageURL()
        try? FileManager().removeItem(at: oldURL)
        
        // set new image
        forceDesktopImageRefreshID += 1
        let imageURL = generateImageURL()
        window.saveToImage(url: imageURL)
        set(imageURL: imageURL)
    }
    
    private static func generateImageURL() -> URL {
        let filename = "DesktopBackground-\(forceDesktopImageRefreshID).png"
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(filename)
        return url!
    }
    
}
