//
//  ImageSaver.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/25/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}
extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}
extension NSImage {
    var png: Data? {
        return tiffRepresentation?.bitmap?.png
    }
    func savePNG(to url: URL) -> Void {
        do {
            try png?.write(to: url)
        } catch {
            print(error)
        }
    }
}
