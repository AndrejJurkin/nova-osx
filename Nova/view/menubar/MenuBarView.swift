//
//  MenuBarView.swift
//  Nova
//
//  Created by Andrej Jurkin on 13/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

/// Menu bar view displays selected tickers in menu bar
class MenuBarView: NSObject {
    
    /// Status item used to display coin tickers
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    let popover = NSPopover()
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.statusItem.button?.action = #selector(togglePopover)
        self.statusItem.button?.target = self
        
        self.setStatusItemTitle(title: "NOVA")
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let popoverViewController = storyboard.instantiateController(
            withIdentifier: "popover") as! TickerListViewController
        
        self.popover.contentViewController = popoverViewController
    }
    
    func togglePopover() {
        if popover.isShown {
            self.hidePopover()
        } else {
            self.showPopover()
        }
    }
    
    func showPopover() {
        if let button = statusItem.button {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func hidePopover() {
        self.popover.performClose(nil)
    }
    
    func setStatusItemTitle(title: String) {
        let title = NSAttributedString(string: title, attributes: R.Font.menuBarTitleAttributes)
        
        self.statusItem.attributedTitle = title
    }
}
