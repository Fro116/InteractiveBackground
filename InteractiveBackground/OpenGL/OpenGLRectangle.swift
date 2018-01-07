//
//  OpenGLRectangle.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 1/1/18.
//  Copyright © 2018 Kundan Chintamaneni. All rights reserved.
//

import Cocoa
import OpenGL.GL3

class OpenGLRectangle {
    
    /**
     * Creates a rectangle to render a texture
     *
     * - parameter bounds: the position and size of the rectangle in
     *     normalized coordinates. (-1, -1) is the bottom left
     *     and (1, 1) is the top right
     */
    public init(bounds: CGRect) {
        // For each row (x,y,u,v), (x,y) is the position and (u,v) is the texture
        let data: [GLfloat] = [GLfloat(bounds.minX), GLfloat(bounds.minY), 0.0, 1.0, // BL
                               GLfloat(bounds.minX), GLfloat(bounds.maxY), 0.0, 0.0, // TL
                               GLfloat(bounds.maxX), GLfloat(bounds.maxY), 1.0, 0.0, // TR
                               GLfloat(bounds.maxX), GLfloat(bounds.minY), 1.0, 1.0] // BR
        
        // create vertex object
        glGenVertexArrays(1, &vaoID)
        glBindVertexArray(vaoID)
        
        // create vertex buffer
        glGenBuffers(1, &vboID)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboID)
        glBufferData(GLenum(GL_ARRAY_BUFFER), data.count * MemoryLayout<GLfloat>.size, data, GLenum(GL_STATIC_DRAW))
        
        // structure array data
        let bytesInGLFloat : GLuint = 4
        let floatsPerPoint : GLuint = 4
        let stride : GLsizei = GLsizei(bytesInGLFloat * floatsPerPoint);
        
        // vertex data
        let offset1 = Int(0*bytesInGLFloat);
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), stride, UnsafePointer<GLuint>(bitPattern: offset1))
        glEnableVertexAttribArray(0)

        // texture data
        let offset2 = Int(2*bytesInGLFloat);
        glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), stride, UnsafePointer<GLuint>(bitPattern: offset2))
        glEnableVertexAttribArray(1)
        
        // element data
        let elementBufferData : [GLushort] = [3, 2, 0, 1]
        glGenBuffers(1, &eboID);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), eboID);
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferData.count * MemoryLayout<GLushort>.size, elementBufferData, GLenum(GL_STATIC_DRAW));
        
        glBindVertexArray(0)
    }
    
    /**
     * Replaces the current texture
     *
     * - parameter texture: a handle to the texture
     */
    public func setTexture(texture : GLuint) {
        self.texture = texture;
    }
    
    /**
     * Draws the rectangle at its current position
     */
    public func draw() {
        if let tboID = texture {
            glBindVertexArray(vaoID)
            glBindTexture(GLenum(GL_TEXTURE_2D), tboID)
            
            glDrawElements(GLenum(GL_TRIANGLE_STRIP), 4, GLenum(GL_UNSIGNED_SHORT), nil);
            
            glBindVertexArray(0)
            glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        }
    }
    
    /**
     * Cleans up OpenGL resources
     */
    deinit {
        glDeleteVertexArrays(1, &vaoID)
        glDeleteBuffers(1, &vboID)
        glDeleteBuffers(1, &eboID)
    }
    
    /// handle to the texture
    private var texture : GLuint?
    
    /// handle to the vertex array object
    private var vaoID: GLuint = 0
    
    /// handle to the vertex buffer object
    private var vboID: GLuint = 0
    
    /// handle to the element buffer object
    private var eboID: GLuint = 0
}

