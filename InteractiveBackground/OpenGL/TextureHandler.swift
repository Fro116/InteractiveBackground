//
//  TextureProducer.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 1/7/18.
//  Copyright © 2018 Kundan Chintamaneni. All rights reserved.
//

import OpenGL.GL3

/**
 * Manages an OpenGL texture. Classes implenting this interface
 * are responsible for the allocation and deallocation of textures
 */
protocol TextureHandler {
    
    /**
     * Generates a texture
     *
     * - returns: a handle to the texture slot managed by this object
     */
    func texture() -> GLuint
    
    /**
     * Draws an image to the texture slot managed by this object
     */
    func update()
    
}
