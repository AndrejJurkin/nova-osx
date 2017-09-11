//
//  Copyright 2017 Andrej Jurkin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  AppDelegate.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.title = "NOVA"
        self.statusItem.button?.action = #selector(togglePopover)
        
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

}

