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
import RxSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    let disposeBag = DisposeBag()
    let titleAttributes: [String: Any] = [NSFontAttributeName: NSFont(name: "Avenir Next", size: 12.0)!]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem.button?.action = #selector(togglePopover)
        
        
        self.setStatusItemTitle(title: "NOVA")
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let popoverViewController = storyboard.instantiateController(
            withIdentifier: "popover") as! TickerListViewController
        
        self.popover.contentViewController = popoverViewController
        
        self.subscribeForUpdates(base: "OMG", refreshInterval: 30.0)
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
    
    func subscribeForUpdates(base: String, refreshInterval: Float) {
        Observable<Int>.interval(RxTimeInterval(refreshInterval), scheduler: MainScheduler.instance)
            .flatMap { _ -> Observable<CryptonatorTickerResponse> in
                return Api.shared.getTicker(base: base, target: "USD")
            }
            .subscribe(onNext: { response in
                guard response.success == true, let ticker = response.ticker else {
                    // TODO: notify error
                    return
                }
                
                print("Ticker updated")
                self.setStatusItemTitle(title: String(format: "%@ $%.2f", base, ticker.price))
            })
            .addDisposableTo(disposeBag)
    }
    
    func setStatusItemTitle(title: String) {
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        
        self.statusItem.attributedTitle = title
    }

}

