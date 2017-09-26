//
//  ContactViewController.swift
//  Nova
//
//  Created by Andrej Jurkin on 26/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Cocoa

class ContactViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.setTransparentTitle()
        AppDelegate.shared().menuBarView?.hidePopover()
    }
}
