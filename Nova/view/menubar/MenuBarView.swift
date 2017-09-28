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
//  MenuBarView.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.

import Foundation
import Cocoa
import RxSwift
import RxCocoa

/// Menu bar view displays selected tickers in menu bar
class MenuBarView: NSObject {
    
    /// Status item used to display coin tickers
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    /// Content wrapper
    let popover = NSPopover()
    
    let viewModel = Injector.inject(type: MenuBarViewModel.self)
    
    let disposeBag = DisposeBag()
    
    private var eventMonitor: EventMonitor?
    
    override init() {
        super.init()
        
        self.statusItem.button?.action = #selector(togglePopover)
        self.statusItem.button?.target = self
    
        self.bindUi()
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        let popoverViewController = storyboard.instantiateController(
            withIdentifier: "popover") as! TickerListViewController
        
        self.popover.contentViewController = popoverViewController
        
        // Close popover on any click outside of the app
        self.eventMonitor = EventMonitor(
            mask: [.leftMouseDown, .rightMouseDown],
            handler: { [weak self] event in
                self?.hidePopover()
            })
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
            self.eventMonitor?.start()
        }
    }
    
    func hidePopover() {
        self.popover.performClose(nil)
        self.eventMonitor?.stop()
    }
    
    func setStatusItemTitle(title: String) {
        let title = NSAttributedString(string: title, attributes: R.Font.menuBarTitleAttributes)
        
        self.statusItem.attributedTitle = title
    }
    
    func refresh() {
        self.viewModel.subscribe()
    }
    
    func pause() {
        self.viewModel.unsubscribe()
    }
    
    func resume() {
        self.viewModel.subscribe()
    }
    
    private func bindUi() {
        self.viewModel.subscribe()
        self.viewModel.menuBarText.asObservable().subscribe(onNext: { text in
            self.setStatusItemTitle(title: text)
        })
        .addDisposableTo(disposeBag)
    }
}
