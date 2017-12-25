//
//  AppDelegate.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/20/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let pid: Int32 = 3581
    typealias window_t = [String : AnyObject]
    let WINDOW_NAME = "Monika After Story"

    private func handleMouseEvent(event: NSEvent) -> Void {
        let enterCode = CGKeyCode(kVK_Return)
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: enterCode, keyDown: true)!
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: enterCode, keyDown: false)!
        keyDownEvent.postToPid(pid)
        keyUpEvent.postToPid(pid)
    }
    
    private func handleLocalMouseEvent(event: NSEvent) -> NSEvent? {
        handleMouseEvent(event: event)
        return nil;
    }
    
    private func handleGlobalMouseEvent(event: NSEvent) -> Void {
        handleMouseEvent(event: event)
    }
    
    private func selectWindow(windowList: [window_t], name: String) -> window_t? {
        for window in windowList {
            if let windowName = window["kCGWindowName"] {
                if windowName as! String == name {
                    return window
                }
            }
        }
        return nil
    }
    
    private func getWindowList() -> [window_t] {
        let listOptions = CGWindowListOption.optionAll
        let relativeToWindow = CGWindowID(kCGNullWindowID)
        let windowList = CGWindowListCopyWindowInfo(listOptions, relativeToWindow)
        return windowList as! [window_t]
    }
    
    private func saveImage(window: window_t, url: URL) {
        let id = window["kCGWindowNumber"] as! CGWindowID
        let rawBounds = window["kCGWindowBounds"] as! CFDictionary
        let bounds = CGRect(dictionaryRepresentation: rawBounds)!
        let resolution = CGWindowImageOption.bestResolution
        let selector = CGWindowListOption.optionIncludingWindow
        let rawImage = CGWindowListCreateImage(bounds, selector, id, resolution)!
        let image = NSImage(cgImage: rawImage, size: NSZeroSize)
        image.savePNG(to: url)
    }
    
    @objc func update() -> Void {
        setDesktopBackground(windowName: WINDOW_NAME)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mask : NSEvent.EventTypeMask = [NSEvent.EventTypeMask.leftMouseUp]
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handleGlobalMouseEvent)
        NSEvent.addLocalMonitorForEvents(matching: mask, handler: handleLocalMouseEvent)
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

