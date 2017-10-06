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

    private var prefs: Prefs
    
    private var tickerUpdateSubscription: Disposable?
    
    private var globalRefreshSubscription: Disposable?
    
    private var disposeBag = DisposeBag()
    
    private var refreshSubscriptions = DisposeBag()
    
    private var tickerUpdateTimestamp: Date?
   
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
    ///
    /// - Query remote repository for update and cache into Realm
    /// - Changes in Realm will automatically trigger update of UI
    /// - Sorted by market cap
    ///
    /// - returns:
    /// An observable of type `Ticker`
    func getAllTickers() -> Observable<[Ticker]> {
        self.remote.getAllTickers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tickers in
                self.local.saveTickers(tickers: tickers)
            })
            .addDisposableTo(disposeBag)
        
        return self.local.getAllTickers()
    }
    
    /// Get all tickers from remote repository and cache response into Realm
    ///
    /// - returns:
    /// An empty observable to notify the UI when finished
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
    

    
    
    /// Request fresh prices from CryptoCompare api
    /// Update local repository on response
    ///
    /// - parameters: 
    ///    - baseSymbols: The array of crypto currency symbols (BTC, ETH, XRP...)
    ///    - refreshInterval: 
    ///      The refresh interval in seconds. Default value is 15 seconds.
    func subscribeForTickerUpdates(baseSymbols: [String], refreshInterval: Float = 15.0) {
        print("Subscribe for ticker updates")
        self.tickerUpdateSubscription?.dispose()
        
        self.tickerUpdateSubscription =
            Observable<Int>
                .timer(0, period: RxTimeInterval(refreshInterval), scheduler: Schedulers.background)
                // Query CryptoCompare api for an update
                .flatMap({ _ -> Observable<[String: [String: Double]]> in
                    return self.remote.getTickers(base: baseSymbols)
                })
                .retryWithDelay(timeInterval: Int(refreshInterval))
                .subscribe(onNext: { tickers in
                    let timestamp = DateFormatter.localizedString(
                        from: NSDate() as Date, dateStyle: .none, timeStyle: .medium)

                    print("Pinned tickers updated at: \(timestamp)")
                    self.local.updateTickerPrices(tickers: tickers)
                }, onError: { error in
                    print(error)
                })
        
        self.tickerUpdateSubscription?.addDisposableTo(refreshSubscriptions)
    }
    
    /// Request fresh prices from CoinMarketCap
    /// Update local repository on response
    /// 
    /// - parameters:
    ///    - refreshIntervalMinutes: The refresh interval in minutes.
    ///    Min. value is 5 minutes, since CMC endpoint refreshes every 5 minutes.
    func subscribeForGlobalUpdates(refreshIntervalMinutes: Int = 5) {
        print("Subscribe for global updates")
        guard refreshIntervalMinutes >= 5 else {
            fatalError("Do not use refrsh interval of less than 5 minutes." +
                "CoinMarketCap endpoint refreshes every 5 minutes")
        }
        
        self.globalRefreshSubscription?.dispose()
        
        self.globalRefreshSubscription =
            Observable<Int>.timer(0, period: RxTimeInterval(refreshIntervalMinutes * 60), scheduler: Schedulers.background)
            // Query Cryptonator api for an update
            .flatMap { _ -> Observable<[Ticker]> in
                
                return self.remote.getAllTickers()
            }
            .subscribe(onNext: { tickers in
                print("All tickers updated.")
                self.local.saveTickersAsync(tickers: tickers)
            }, onError: { error in
                print(error)
            })
        
        self.globalRefreshSubscription?.addDisposableTo(refreshSubscriptions)
    }
    
    func disposeTickerSubscription() {
        self.tickerUpdateSubscription?.dispose()
    }
    
    /// Terminate all running refresh subscriptions
    func disposeRefreshSubscriptions() {
        self.refreshSubscriptions = DisposeBag()
    }
}
