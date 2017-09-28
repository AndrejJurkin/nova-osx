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
//  MenuBarViewModel.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.

import Foundation
import RxSwift

class MenuBarViewModel {
    
    let repo: DataRepository
    
    let prefs: Prefs
    
    var menuBarText = Variable(R.String.appName)
    
    let disposeBag = DisposeBag()
    
    init(repo: DataRepository, prefs: Prefs) {
        self.repo = repo
        self.prefs = prefs
    }
    
    func subscribe() {
        // Watch when list with pinned tickers changes
        self.repo.getPinnedTickers()
            .retry(5)
            .flatMap({ tickers -> Observable<[String]> in
                
                // If we don't have any pinned tickers, show app name
                guard tickers.count > 0 else {
                    self.repo.disposeTickerSubscription()
                    self.menuBarText.value = R.String.appName
                    return Observable.just([])
                }
                
                var menuBarText = ""
                var tickerSymbols: [String] = []
                
                // Create menu bar string representation
                for ticker in tickers {
                    let priceFormat = ticker.priceUsd < 1 ? "%.4f" : "%.2f"
                    let priceFormatted = String(format: priceFormat, ticker.priceUsd)
                    menuBarText.append("\(ticker.symbol) \(priceFormatted)   ")
                    
                    tickerSymbols.append(ticker.symbol)
                }
                
                self.menuBarText.value = menuBarText.trim()
                return Observable.just(tickerSymbols)
            })
            
            // Distinct if pinned tickers array has the same size
            // This is to avoid re-subscribing after values update
            .distinctUntilChanged({ (old, new) -> Bool in
                
                return old.count == new.count
            })
            .filter { $0.count != 0 }
            .subscribe(onNext: { tickerSymbols in
                
                // Subscribe for updates for given ticker symbols
                self.repo.subscribeForTickerUpdates(baseSymbols: tickerSymbols)
            })
            .addDisposableTo(disposeBag)
        
        self.repo.subscribeForGlobalUpdates()
    }
    
    func unsubscribe() {
        self.repo.disposeRefreshSubscriptions()
    }
}
