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
     * Forwards events that interact with the desktop background
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
        
        /**
         * Adapter to bridge an ApplicationInterface with a TextureHandler
         */
        class DesktopPainter : TextureHandler {
            
            init(app: ApplicationInterface) {
                m_app = app
            }
            
            func texture() -> GLuint {
                if m_texture == 0 {
                    m_texture = OpenGLUtility.generateTexture()
                }
                return m_texture
            }
            
            func update() {
                if let image = m_app.image() {
                    OpenGLUtility.loadTexture(image: image, id: m_texture)
                }
            }
            
            deinit {
                glDeleteTextures(1, &m_texture)
            }
            
            let m_app : ApplicationInterface
            var m_texture : GLuint = 0
        }
        
        let textureProducer = DesktopPainter(app: m_app)
        let animationView = view.subviews[0] as! AnimationView
        animationView.setAnimation(animationProducer: textureProducer)
 
        
        // set up event forwarding
        //let mask : NSEvent.EventTypeMask = [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.leftMouseUp]
        //NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handleEvent)
    }

    /// the application to set as the desktop background
    private let m_app : ApplicationInterface = MonikaAfterStoryAdapter()
    
 
}

