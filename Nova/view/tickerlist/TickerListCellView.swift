//
//  TickerListCellView.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/10/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import Cocoa

class TickerListCellView: NSTableCellView {
    
    @IBOutlet weak var currencyImageView: NSImageView!
    
    @IBOutlet weak var currencyName: NSTextField!
    
    @IBOutlet weak var currencyPrice: NSTextField!
    
    @IBOutlet weak var pinButton: NSButton!
}
