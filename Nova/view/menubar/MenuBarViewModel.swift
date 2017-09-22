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
    
    let repo = Injector.inject(type: DataRepository.self)
    
    let prefs = Injector.inject(type: Prefs.self)
    
    var menuBarText = Variable("N O V A")
    
    let disposeBag = DisposeBag()
    
    init() {
        self.repo.getPinnedTickers()
            .subscribe(onNext: { tickers in
                var menuBarText = ""
                var tickerSymbols: [String] = []
                
                for ticker in tickers {
                    let priceFormat = ticker.priceUsd < 1 ? "%.4f" : "%.2f"
                    let priceFormatted = String(format: priceFormat, ticker.priceUsd)
                    menuBarText.append("\(ticker.symbol) \(priceFormatted)   ")
                    
                    tickerSymbols.append(ticker.symbol)
                }
                
                self.repo.subscribeForTickerUpdates(baseSymbols: tickerSymbols)
                self.menuBarText.value = menuBarText.trim()
            })
            .addDisposableTo(disposeBag)
    }
}
