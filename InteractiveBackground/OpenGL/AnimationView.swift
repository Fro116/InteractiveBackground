//
//  AnimationView.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 1/1/18.
//  Copyright © 2018 Kundan Chintamaneni. All rights reserved.
//


import Cocoa
import OpenGL.GL3

/**
 * Displays a continuous animation. This view consists of a rectangle
 * that holds a single texture. Every time the display refreshes,
 * the texture advances to the next frame of the animation and
 * the view is redrawn.
 */
final class AnimationView: NSOpenGLView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        openGLContext = OpenGLUtility.createContext()
        pixelFormat = openGLContext?.pixelFormat
        openGLContext?.setValues([1], for: .swapInterval)
    }
    
    /**
     * During each frame, the `update` method will be called on
     * the `animationProducer`. The newly updated texture will
     * then be displayed in this view
     *
     * - parameter animationProducer: generates the textures that will
     *       will be displayed in this view
     */
    public func setAnimation(animationProducer: TextureHandler) {
        self.animationProducer = animationProducer
        display?.setTexture(texture: animationProducer.texture())
    }
    
    override func prepareOpenGL() {
        super.prepareOpenGL()
        
        configureOpenGL()
        startAnimation()
        
        // initialize drawing objects
        let bounds = CGRect(x: -1, y: -1, width: 2, height: 2)
        display = OpenGLRectangle(bounds: bounds)
        if let producer = animationProducer {
            display!.setTexture(texture: producer.texture())
        }
    }
    
    /**
     * Sets the OpenGL rendering parameters, including the
     * shaders and the clear color
     */
    private func configureOpenGL() {
        let vertexSource = Bundle.main.url(forResource: "Texture", withExtension: "vertexshader", subdirectory: "")!
        let fragmentSource = Bundle.main.url(forResource: "Texture", withExtension: "fragmentshader", subdirectory: "")!
        programID = OpenGLUtility.createProgram(vertexShader: vertexSource, fragmentShader: fragmentSource)
        glClearColor(0.0, 0.0, 0.0, 1.0)
    }
    
    /**
     * Creates and starts a DisplayLink. This causes `drawView` to
     * be called whenever the monitor refreshes
     */
    private func startAnimation() {
        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = {(displayLink: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
            
            let view = unsafeBitCast(displayLinkContext, to: AnimationView.self)
            view.drawView()
            return kCVReturnSuccess
        }
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        CVDisplayLinkStart(displayLink!)
    }
    
    /**
     * Renders the scene.
     */
    private func drawView() {
        if let context = self.openGLContext {
            // setup
            context.makeCurrentContext()
            CGLLockContext(context.cglContextObj!)
            glUseProgram(programID)
            
            // draw
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            animationProducer?.update()
            display!.draw()
            
            // clean up
            glUseProgram(0)
            CGLFlushDrawable(context.cglContextObj!)
            CGLUnlockContext(context.cglContextObj!)
        }        
    }

    /**
     * Clean up OpenGL resources
     */
    deinit {
        glDeleteProgram(programID)
        CVDisplayLinkStop(displayLink!)
    }
    
    /// a handle to the program shaders
    private var programID: GLuint = 0
    
    /// the display link, which is used for animations
    private var displayLink: CVDisplayLink?
    
    /// a frame that will render the current image
    private var display: OpenGLRectangle?
    
    /// Determines what to draw on each frame
    private var animationProducer : TextureHandler?
    
}

