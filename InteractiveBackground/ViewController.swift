//
//  ViewController.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/20/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private func isBackgroundEvent(event: NSEvent) -> Bool {
        // checks that all windows the point intersects with are below the background level
        let visibleLevel = CGWindowLevel(CGWindowLevelKey.baseWindow.rawValue)
        let backgroundLevel = CGWindowLevel(CGWindowLevelKey.desktopIconWindow.rawValue)
        let location = event.locationInWindow
        return WindowInfo.getWindowList(listOptions: CGWindowListOption.optionOnScreenOnly)
            .filter({$0.windowLevel() >= visibleLevel})
            .filter({$0.bounds().contains(location) == true})
            .map({$0.windowLevel() == backgroundLevel})
            .reduce(true, {$0 && $1})
    }
    
    private func handleEvent(event: NSEvent) {
        // forward events that interact with the desktop background
        if isBackgroundEvent(event: event) {
            handler.handle(event: event)
        }
    }
    
    @objc private func updateImage() {
        if let image = handler.image() {
            imageView!.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set size to be full screen
        self.view.frame = NSScreen.main!.frame
        // set up event forwarding
        let mask : NSEvent.EventTypeMask = [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.leftMouseUp]
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handleEvent)
        // set up image mirroring
        imageView = NSImageView(frame: self.view.frame)
        self.view.addSubview(imageView!)
        Timer.scheduledTimer(timeInterval: frameRate, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private let handler : ApplicationInterface = MonikaAfterstoryAdapter()
    private let frameRate = 0.05
    private var imageView : NSImageView? = nil
}

