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
//  DataRepository.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.

import Foundation
import RxSwift
import RealmSwift

/// Central data source that abstracts fetching and caching of app data
class DataRepository {
    
    private var local: LocalDataSource

    private var remote: RemoteDataSource
    
    private var disposeBag = DisposeBag()

    private var prefs: Prefs
    
    private var refreshSubscriptions = DisposeBag()
   
    init(local: LocalDataSource, remote: RemoteDataSource, prefs: Prefs) {
        self.local = local
        
        self.remote = remote
        self.prefs = prefs
    }
    
    /// Get pinned tickers sorted by orderIndex
    func getPinnedTickers() -> Observable<[Ticker]> {
        return self.local.getPinnedTickers()
    }
    
    /// Set ticker as pinned (show in menu bar)
    func pinTicker(symbol: String) {
        self.local.pinTicker(symbol: symbol)
    }
    
    /// Unpin ticker (remove from menu bar)
    func unpinTicker(symbol: String) {
        self.local.unpinTicker(symbol: symbol)
    }
    
    /// Get all cached tickers from Realm
    /// - Query remote repository for update and cache into Realm
    /// - Changes in Realm will automatically trigger update of UI
    /// - Sorted by market cap
    func getAllTickers() -> Observable<[Ticker]> {
        self.remote.getAllTickers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tickers in
                self.local.saveTickers(tickers: tickers)
            })
            .addDisposableTo(disposeBag)
        
        return self.local.getAllTickers()
    }
    
    /// Get all tickers from remote repository
    func refreshAllTickers() -> Observable<Void> {
        return self.remote.getAllTickers()
            // Cache into Realm
            .do(onNext: { response in
                self.local.saveTickers(tickers: response)
            })
            // Flat map to empty observable since we don't need the result
            .observeOn(MainScheduler.instance)
            .flatMap { _ in
                return Observable.just()
            }
    }
    
    /// Get top N (limit) tickers, sorted by market cap
    func getTopTickers(limit: Int) -> Observable<[Ticker]> {
        
        return self.remote.getTopTickers(limit: limit)
    }
    
    /// Get ticker from Cryptonator api
    ///
    /// Endpoint updates every 30s
    ///
    /// - parameters:
    ///    - base: The base currency symbol (1 base unit is priced at x target units)
    ///    - target: The target currency symbol
    func getTicker(base: String, target: String) -> Observable<CryptonatorTickerResponse> {

        return self.remote.getTicker(base: base, target: target)
    }
    
    /// Subscribe for ticker updates
    ///
    /// - parameters:
    ///    - base: The base currency symbol (BTC, ETH, XRP...)
    ///            one base unit is priced at x target units,
    ///    - refreshInterval: The ticker refresh interval in seconds (min. and default 30.0)
    func subscribeForTickerUpdates(base: String, refreshInterval: Float = 5.0) {
        Observable<Int>.interval(RxTimeInterval(refreshInterval), scheduler: Schedulers.background)
            // Query Cryptonator api for an update
            .flatMap { _ -> Observable<CryptonatorTickerResponse> in
                
                return self.remote.getTicker(base: base, target: self.prefs.targetCurrency)
            }
            // Unsubscribe on error response or if ticker is no longed pinned
            .takeWhile { response in
                response.success == true && self.local.isTickerPinned(symbol: base)
            }
            // Update local db on response
            .subscribe(onNext: { response in
                guard response.success == true, let ticker = response.ticker else {
                    return
                }
                self.local.updatePrice(symbol: ticker.base, newPrice: ticker.price)
            }, onCompleted: { _ in print("ON COMPLETED")})
            .addDisposableTo(refreshSubscriptions)
    }
    
    private func disposeRefreshSubscriptions() {
        self.refreshSubscriptions = DisposeBag()
    }
}
