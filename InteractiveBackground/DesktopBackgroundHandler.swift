//
//  DesktopBackgroundHandler.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/25/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

var rotation = 0

private func setDesktopBackground(imageURL: URL) {
    let screens = NSScreen.screens
    for screen in screens {
        try! NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
    }
}

private func setDesktopBackground(windowName: String) {
    rotation = 1 - rotation
    let windowList = getWindowList()
    let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent("\(rotation).png")!
    if let window = selectWindow(windowList: windowList, name: windowName) {
        saveImage(window: window, url: imageURL)
        setDesktopBackground(imageURL: imageURL)
    }
}
