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
//  TickerListViewController.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Cocoa
import RxSwift
import RxCocoa
import Kingfisher

class TickerListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var searchTextField: NSTextField!
    
    @IBOutlet weak var tickerTableView: NSTableView!
    
    @IBOutlet weak var refreshButton: NSButton!
    
    @IBOutlet var settingsMenu: NSMenu!
    
    var viewModel = Injector.inject(type: TickerListViewModel.self)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.rx.text.orEmpty
            .bindTo(viewModel.searchString)
            .addDisposableTo(disposeBag)
        
        self.viewModel.reloadDataCallback = {
            self.tickerTableView.reloadData()
        }
        
        self.viewModel.isRefreshing.asObservable().subscribe { refreshingState in
            guard let isRefreshing = refreshingState.element else {
                return
            }
            
            if isRefreshing {
                self.refreshButton.isEnabled = false
                self.startRefreshAnimation()
            } else {
                self.refreshButton.isEnabled = true
                self.stopRefreshAnimation()
            }
        }
        .addDisposableTo(disposeBag)
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
        self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = NSColor.clear
        
        self.searchTextField.cursorColor = R.Color.primaryLight
        
        self.viewModel.filteredData
            .asObservable()
            .subscribe(onNext: { _ in
                self.tickerTableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onRefreshButtonClick(_ sender: Any) {
        self.viewModel.refresh()
        
        // TODO: Inject view
        AppDelegate.shared().menuBarView?.refresh()
    }
    
    @IBAction func onSettingsButtonClick(_ sender: Any) {
        self.settingsMenu.popUp(positioning: self.settingsMenu.item(at: 0),
                                at: NSEvent.mouseLocation(), in: nil)
    }
    
    @IBAction func onLicenseClick(_ sender: AnyObject) {
        self.openPdf(resourceName: "license")
    }
    
    @IBAction func onAcknowledgementsClick(_ sender: AnyObject) {
        self.openPdf(resourceName: "acknowledgements")
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let view = tableView.make(withIdentifier: "Cell", owner: self) as! TickerListCellView
        
        view.currencyName.stringValue = self.viewModel.getCurrencyName(row: row)
        view.currencyImageView.kf.setImage(with: self.viewModel.getCurrencyImageUrl(row: row))
        view.currencyPrice.stringValue = self.viewModel.getCurrencyPriceUsd(row: row)
        
        view.pinButton.tag = row
        view.pinButton.target = self
        view.pinButton.action = #selector(onPinButtonClick(sender:))
        view.pinButton.state = self.viewModel.pinButtonState(row: row)
        
        return view
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 48.0
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.viewModel.numberOfRows
    }
    
    func onPinButtonClick(sender: NSButton) {
        self.viewModel.pinStatusChanged(row: sender.tag, pinned: sender.state == 1)
    }
    
    func startRefreshAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = -M_PI * 2
        anim.duration = 0.75
        anim.repeatCount = HUGE
        
        if let frame = self.refreshButton.layer?.frame {
            let center = CGPoint(x: frame.midX, y: frame.midY)
            self.refreshButton.layer?.position = center
            self.refreshButton.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.refreshButton.layer?.add(anim, forKey: nil)
        }
    }
    
    func stopRefreshAnimation() {
         self.refreshButton.layer?.removeAllAnimations()
    }

    
    func openPdf(resourceName: String) {
        AppDelegate.shared().menuBarView?.hidePopover()
        
        if let pdfURL = Bundle.main.url(forResource: resourceName, withExtension: "pdf"){
            NSWorkspace.shared().open(pdfURL)
        }
    }
}

