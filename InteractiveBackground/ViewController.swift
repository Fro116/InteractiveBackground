//
//  ViewController.swift
//  InteractiveBackground
//
//  Created by Kundan Chintamaneni on 12/20/17.
//  Copyright © 2017 Kundan Chintamaneni. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // set size to be full screen
        self.view.frame = NSScreen.main!.frame
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

