//
//  OpenGLUtility.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 1/1/18.
//  Copyright © 2018 Kundan Chintamaneni. All rights reserved.
//

import Cocoa
import OpenGL.GL3

final class OpenGLUtility {
    
    /**
     * Initializes an OpenGL context
     *
     * - returns: an OpenGL context, if one could be created
     */
    public static func createContext() -> NSOpenGLContext? {
        let attrs: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAAccelerated),
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(NSOpenGLPFAColorSize), UInt32(32),
            UInt32(NSOpenGLPFAOpenGLProfile), UInt32(NSOpenGLProfileVersion3_2Core),
            UInt32(0)
        ]
        guard let pixelFormat = NSOpenGLPixelFormat(attributes: attrs) else {
            Swift.print("pixelFormat could not be constructed")
            return nil
        }
        guard let context = NSOpenGLContext(format: pixelFormat, share: nil) else {
            Swift.print("context could not be constructed")
            return nil
        }
        return context
    }
    
    /**
     * Sets up an OpenGL program
     *
     * - parameter vertexShader: the source text of the vertex shader file
     * - parameter fragmentShader: the source text of the fragment shader file
     * - returns: the handle to the program
     */
    public static func createProgram(vertexShader : URL, fragmentShader : URL) -> GLuint {
        let programID = glCreateProgram()
        
        let vertexType = GLenum(GL_VERTEX_SHADER)
        let vertexSource = try! String(contentsOf: vertexShader, encoding: String.Encoding.ascii)
        OpenGLUtility.attachShader(text: vertexSource, shaderType: vertexType, programID : programID)
        
        let fragmentType = GLenum(GL_FRAGMENT_SHADER)
        let fragmentSource = try! String(contentsOf: fragmentShader, encoding: String.Encoding.ascii)
        OpenGLUtility.attachShader(text: fragmentSource, shaderType: fragmentType, programID: programID);
        
        OpenGLUtility.linkProgram(programID: programID)
        return programID
    }
    
    /**
     * Loads the image into a newly allocated texture
     *
     * - parameter image: the texture data
     * - returns: a handle to the texture
     */
    public static func loadTexture(image : CGImage) -> GLuint {
        let tboID: GLuint = generateTexture()
        loadTexture(image: image, id: tboID)        
        return tboID
    }
    
    /**
     * Loads the image into a texture
     *
     * - parameter image: the texture data
     * - parameter id: the texture slot to bind
     */
    public static func loadTexture(image: CGImage, id: GLuint) {
        let tboID: GLuint = id
        
        let bitsInByte = 8;
        let numBytes = image.bitsPerPixel / bitsInByte * image.width * image.height
        let textureData = UnsafeMutableRawPointer.allocate(bytes: numBytes, alignedTo: MemoryLayout<GLint>.alignment)
        let context = CGContext(data: textureData, width: image.width, height: image.height, bitsPerComponent: bitsInByte, bytesPerRow: image.bytesPerRow, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        context?.draw(image, in: CGRect(x: 0.0, y: 0.0, width: Double(image.width), height: Double(image.height)))
        
        let a = NSDate().timeIntervalSince1970
        glBindTexture(GLenum(GL_TEXTURE_2D), tboID)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(image.width), GLsizei(image.height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), textureData)
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        free(textureData)
        let b = NSDate().timeIntervalSince1970
        print(b-a)
    }
    
    /**
     * Creates a newly allocated texture
     *
     * - returns: a handle to the texture
     */
    public static func generateTexture() -> GLuint {
        var tboID: GLuint = 0
        glGenTextures(1, &tboID)
        return tboID
    }
    
    /**
     * Links the program after shaders have been attached
     *
     * - parameter programID: a handle to the program
     */
    private static func linkProgram(programID : GLuint) {
        // link program
        glLinkProgram(programID)
        var linked: GLint = 0
        glGetProgramiv(programID, UInt32(GL_LINK_STATUS), &linked)
        
        // test for errors
        if linked <= 0 {
            Swift.print("Could not link, getting log")
            var logLength: GLint = 0
            glGetProgramiv(programID, UInt32(GL_INFO_LOG_LENGTH), &logLength)
            Swift.print(" logLength = \(logLength)")
            if logLength > 0 {
                let cLog = UnsafeMutablePointer<CChar>.allocate(capacity: Int(logLength))
                glGetProgramInfoLog(programID, GLsizei(logLength), &logLength, cLog)
                Swift.print("Program Error Log: \(String.init(cString: cLog))")
                free(cLog)
            }
        }
    }
    
    /**
     * Attaches a shader to the given program
     *
     * -parameter text: the source text of the shader file
     * -parameter shaderType: either GL_FRAGMENT_SHADER or GL_VERTEX_SHADER
     * -parameter programID: a handle to the program
     */
    private static func attachShader(text : String, shaderType : GLenum, programID : GLuint) {
        // compile shader
        let vs = glCreateShader(shaderType)
        let vss = text.cString(using: String.Encoding.ascii)
        var vssptr = UnsafePointer<GLchar>(vss)
        glShaderSource(vs, 1, &vssptr, nil)
        glCompileShader(vs)
        
        // test for errors
        var compiled: GLint = 0
        glGetShaderiv(vs, GLbitfield(GL_COMPILE_STATUS), &compiled)
        if compiled <= 0 {
            Swift.print("Could not compile, getting log")
            var logLength: GLint = 0
            glGetShaderiv(vs, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            Swift.print(" logLength = \(logLength)")
            if logLength > 0 {
                let cLog = UnsafeMutablePointer<CChar>.allocate(capacity: Int(logLength))
                glGetShaderInfoLog(vs, GLsizei(logLength), &logLength, cLog)
                Swift.print("Vert Error Log = \(String.init(cString: cLog))")
                free(cLog)
            }
        }
        
        // link shader
        glAttachShader(programID, vs)
        glDeleteShader(vs)
    }
    
}


