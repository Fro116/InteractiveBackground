//
//  EventHandler.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/26/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Foundation
import Cocoa

protocol EventHandler {
    
    func handle(event: NSEvent) -> Void    
    
}
