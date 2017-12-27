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
class Window {
    
    typealias window_t = [String : AnyObject]
    
    public static func getWindowList(listOptions : CGWindowListOption)  -> [Window] {
        let relativeToWindow = CGWindowID(kCGNullWindowID)
        let windowList = CGWindowListCopyWindowInfo(listOptions, relativeToWindow) as! [window_t]
        return windowList.map({Window(window: $0)})
    }
    
    public init(window: window_t) {
        m_window = window
    }    
    
    public func name() -> String? {
        return m_window["kCGWindowName"] as? String
    }
    
    public func pid() -> Int32? {
        return m_window["kCGWindowOwnerPID"] as? Int32
    }
    
    public func windowID() -> CGWindowID? {
        return m_window["kCGWindowNumber"] as? CGWindowID
    }
    
    public func windowLevel() -> CGWindowLevel? {        
        return  m_window["kCGWindowLayer"] as? CGWindowLevel
    }
    
    public func bounds() -> CGRect? {
        if let bounds = m_window["kCGWindowBounds"] {
            return CGRect(dictionaryRepresentation: bounds as! CFDictionary)
        }
        return nil
    }
    
    public func saveToImage(url: URL) {
        if let region = bounds(), let id = windowID() {
            let resolution = CGWindowImageOption.bestResolution
            let selector = CGWindowListOption.optionIncludingWindow
            let rawImage = CGWindowListCreateImage(region, selector, id, resolution)!
            // tells NSImage constructor to copy the size from rawImage
            let rawImageSize = NSZeroSize
            let image = NSImage(cgImage: rawImage, size: rawImageSize)
            image.savePNG(to: url)
        }
    }
    
    public let m_window : window_t
    
}


