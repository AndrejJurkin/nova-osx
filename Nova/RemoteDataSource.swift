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
//  RemoteDataSource.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.

import Foundation
import RxSwift
import Moya

class RemoteDataSource {
    
    private var coinMarketCapProvider: RxMoyaProvider<CoinMarketCapProvider>
    private var cryptonatorProvider: RxMoyaProvider<CryptonatorProvider>
    private let providerPlugins = [NetworkLoggerPlugin()]
    
    init(coinMarketCapProvider: RxMoyaProvider<CoinMarketCapProvider>,
         cryptonatorProvider: RxMoyaProvider<CryptonatorProvider>) {
        
        self.coinMarketCapProvider = coinMarketCapProvider
        self.cryptonatorProvider = cryptonatorProvider
    }
    
    /// Get all available tickers from CoinMarketCap
    func getAllTickers() -> Observable<[Ticker]> {
        
        return self.coinMarketCapProvider.request(.allTickers)
            .map(toArray: Ticker.self)
    }
    
    /// Get top N (limit) tickers, sorted by market cap
    func getTopTickers(limit: Int) -> Observable<[Ticker]> {
        
        return self.coinMarketCapProvider.request(.topTickers(limit: limit))
            .map(toArray: Ticker.self)
    }
    
    /// Get ticker for a single crypto currency
    func getTicker(currencyName: String) -> Observable<Ticker> {
        
        return self.coinMarketCapProvider.request(.ticker(currencyName: currencyName))
            .map(to: Ticker.self)
    }
    
    /// Get ticker from Cryptonator api
    ///
    /// Endpoint updates every 30s
    ///
    /// - Parameters:
    ///    - base: The base currency symbol (1 base unit is priced at x target units)
    ///    - target: The target currency symbol
    func getTicker(base: String, target: String) -> Observable<CryptonatorTickerResponse> {
        
        return self.cryptonatorProvider.request(.ticker(base: base, target: target))
            .map(to: CryptonatorTickerResponse.self)
    }
}
