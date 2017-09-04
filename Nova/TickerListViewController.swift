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

class TickerListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var searchTextField: NSTextField!
    @IBOutlet weak var tickerTableView: NSScrollView!
    
    var viewModel = TickerListViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.rx.text.orEmpty
            .bindTo(viewModel.searchString)
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
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 1
    }
}

