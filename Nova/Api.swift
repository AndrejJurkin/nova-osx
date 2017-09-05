//
//  CoinMarketCapDataSource.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class Api {
    
    public static let shared: Api = Api()
    
    private var provider: RxMoyaProvider<CoinMarketCapProvider>
    private let providerPlugins = [NetworkLoggerPlugin()]
    
    init() {
        self.provider = RxMoyaProvider(plugins: providerPlugins)
    }
    
    /// Get all crypto currency tickers
    func getAllTickers() -> Observable<[Ticker]> {
        
        return self.provider.request(.allTickers)
            .map(toArray: Ticker.self)
    }
    
    /// Get top N (limit) tickers, sorted by market cap
    func getTopTickers(limit: Int) -> Observable<[Ticker]> {
        
        return self.provider.request(.topTickers(limit: limit))
            .map(toArray: Ticker.self)
    }
    
    /// Get ticker for single crypto currency
    func getTicker(currencyName: String) -> Observable<Ticker> {
        
        return self.provider.request(.ticker(currencyName: currencyName))
            .map(to: Ticker.self)
    }
}
