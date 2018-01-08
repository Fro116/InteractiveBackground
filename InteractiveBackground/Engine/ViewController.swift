//
//  ViewController.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/20/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    /**
     * Tests whether the event interacts with the desktop background
     *
     *  - returns: true if the event hits the background
     */
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
    
    /**
     * Checks if the event interacts with `app` and if so,
     * forwards the event.
     *
     * - paramter event: a mouse or keyboard event
     */
    private func handleEvent(event: NSEvent) {
        if isBackgroundEvent(event: event) {
            m_app.handle(event: event)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set size to be full screen
        let fullScreen = NSScreen.main!.frame
        view.frame = fullScreen
        
        // set up desktop background drawing
        let textureProducer = ApplicationTextureHandler(app: m_app)
        let animationView = view.subviews[0] as! AnimationView
        animationView.setAnimation(animationProducer: textureProducer)
        
        // set up event forwarding
        let mask : NSEvent.EventTypeMask = [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.leftMouseUp]
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handleEvent)
    }
    
    /**
     * Adapter to bridge an ApplicationInterface with a TextureHandler
     * The generated textures are screenshots of the application
     */
    private class ApplicationTextureHandler : TextureHandler {
        
        /**
         * Creates a `TextureHandler` to mirror the given app
         *
         * - parameter app: the application to draw
         */
        init(app: ApplicationInterface) {
            m_app = app
        }
        
        func texture() -> GLuint {
            if m_texture == 0 {
                m_texture = OpenGLUtility.generateTexture()
            }
            return m_texture
        }
        
        /**
         * Sets the texture to the current screenshot of the application
         */
        func update() {
            if let image = m_app.image() {
                OpenGLUtility.loadTexture(image: image, id: m_texture)
            }
        }
        
        /**
         * Clean up OpenGL resources
         */
        deinit {
            glDeleteTextures(1, &m_texture)
        }
        
        /// the application that this object is tracking
        let m_app : ApplicationInterface
        
        /// the texture managed by this object
        var m_texture : GLuint = 0
    }

    /// the application to set as the desktop background
    private let m_app : ApplicationInterface = MonikaAfterStoryAdapter()
    
}

