//
//  Window.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Wrapper around the window type returned by CGWindowList* routines
 */
class WindowInfo {
    
    private typealias window_t = [String : AnyObject]
    
    /**
     * Obtains information about all windows
     *
     * - parameter listOptions: a mask to select certain windows
     * - returns: all windows that satisfy the listOptions
     */
    public static func getWindowList(listOptions : CGWindowListOption)  -> [WindowInfo] {
        let relativeToWindow = CGWindowID(kCGNullWindowID)
        let windowList = CGWindowListCopyWindowInfo(listOptions, relativeToWindow) as! [window_t]
        return windowList.map({WindowInfo(window: $0)})
    }
    
    /**
     * Creates a WindowInfo object
     *
     * - parameter window_t: a dictionary containting the Required Window List Keys
     */
    private init(window: window_t) {
        m_window = window
    }    
    
    /**
     * - returns: this window's name
     */
    public func name() -> String? {
        return m_window["kCGWindowName"] as? String
    }
    
    /**
     * - returns: this process ID of the process controlling
     *            this window
     */
    public func pid() -> Int32 {
        return m_window["kCGWindowOwnerPID"] as! Int32
    }
    
    /**
     * Each window is assigned a unique number by the
     * operating system.
     *
     * - returns: this window's number
     */
    public func windowID() -> CGWindowID {
        return m_window["kCGWindowNumber"] as! CGWindowID
    }
    
    /**
     * Windows are displayed on the screen in order of
     * increasing window level. A window with a level of 4
     * will appear on top of a window with a level of 3.
     *
     * - returns: this window's level
     */
    public func windowLevel() -> CGWindowLevel {
        return  m_window["kCGWindowLayer"] as! CGWindowLevel
    }
    
    /**
     * - returns: this window's size
     */
    public func bounds() -> CGRect {
        let bounds =  m_window["kCGWindowBounds"] as! CFDictionary
        return CGRect(dictionaryRepresentation: bounds)!
    }
    
    /**
     * Captures the current image from the window. Requires
     * that the window has not been moved since creating this
     * object
     *
     * - returns: an image of this window
     */
    public func image() -> NSImage {
        let region = bounds()
        let id = windowID()
        let resolution = CGWindowImageOption.bestResolution
        let selector = CGWindowListOption.optionIncludingWindow
        let rawImage = CGWindowListCreateImage(region, selector, id, resolution)!
        // tells NSImage constructor to copy the size from rawImage
        let rawImageSize = NSZeroSize
        let image = NSImage(cgImage: rawImage, size: rawImageSize)
        return image
    }
    
    /// A dictionary containing Required Window List Keys
    private let m_window : window_t
    
}


