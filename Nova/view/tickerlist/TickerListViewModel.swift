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
//  TickerListViewModel.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Foundation
import RxSwift
import RxCocoa

/// Model for TickerList view
class TickerListViewModel {
    
    private let repo = Injector.inject(type: DataRepository.self)
    
    private let prefs = Injector.inject(type: Prefs.self)
    
    /// Raw unfiltered data
    private var data: [Ticker] = []
    
    /// Raw data filtered with search string
    var filteredData = Variable<[Ticker]>([])
    
    /// User input, filter raw data
    var searchString = Variable<String>("")
    
    /// Number of rows for tableview
    var numberOfRows: Int {
        return filteredData.value.count
    }
    
    /// Callback to notify tableview of data changes
    var reloadDataCallback: (()->())?
    
    var pinnedCurrencies = Variable<[String: Double]>([:])

    /// Rx subscriptions
    let disposeBag = DisposeBag()
    
    /// CMC image format
    private let imageUrlFormat = "https://files.coinmarketcap.com/static/img/coins/128x128/%@.png"
    
    init() {
        self.repo.getAllTickers()
            .subscribe(onNext: { tickers in
                self.data = tickers
                self.filteredData.value = self.data
            })
            .addDisposableTo(disposeBag)
        
        self.searchString
            .asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { searchStr in
                self.filterData(query: searchStr)
            })
            .addDisposableTo(disposeBag)
        
        self.pinnedCurrencies.value = self.prefs.pinedCurrencies
        
        self.pinnedCurrencies.asObservable().subscribe { _ in
            print("Pinned currencies updated...")
            
            self.prefs.pinedCurrencies = self.pinnedCurrencies.value
        }
        .addDisposableTo(disposeBag)
    }
    
    /// Get single ticker for tableview row
    func getTicker(row: Int) -> Ticker {
        return self.filteredData.value[row]
    }
    
    /// Currency name for tableview row
    func getCurrencyName(row: Int) -> String {
        return self.getTicker(row: row).name
    }
    
    /// Image url for tableview row
    func getCurrencyImageUrl(row: Int) -> URL? {
        
        let imageName = getTicker(row: row).name
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
        
        let urlString = String.init(format: imageUrlFormat, imageName)
        
        return URL(string: urlString)
    }
    
    func getCurrencyPriceUsd(row: Int) -> String {
        return String(format: "$ %.2f", self.getTicker(row: row).priceUsd)
    }
    
    func pinStatusChanged(row: Int, pinned: Bool) {
        let ticker = getTicker(row: row)
        
        if pinned {
            self.repo.pinTicker(symbol: ticker.symbol)
        } else {
            self.repo.unpinTicker(symbol: ticker.symbol)
        }
    }
    
    func pinButtonState(row: Int) -> Int {
        let ticker = getTicker(row: row)
        
        return self.pinnedCurrencies.value[ticker.symbol] == nil ? 0 : 1
    }
    
    func filterData(query: String) {
        if query.isEmpty {
            // Show all values
            self.filteredData.value = self.data
            self.reloadDataCallback?()
            
            return
        }
        
        self.filteredData.value = self.data.filter {
            $0.name.lowercased().contains(query.lowercased())
                || $0.symbol.lowercased().contains(query.lowercased())
        }
        
        self.reloadDataCallback?()
    }
}
