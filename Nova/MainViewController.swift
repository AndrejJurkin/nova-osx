//
//  ViewController.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/2/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var searchTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.titleVisibility = .hidden
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.styleMask.insert(.fullSizeContentView)
    }
}

