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
//  LocalDataSource.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class LocalDataSource {
    
    /// Asynchroniously cache tickers into Realm
    func saveTickers(tickers: [Ticker]) {
        
        let realm = try! Realm()
        
        try! realm.write {
            for ticker in tickers {
                
                if let currentTicker = realm.object(ofType: Ticker.self, forPrimaryKey: ticker.symbol) {
                    ticker.isPinned.value = currentTicker.isPinned.value
                }
                
                realm.add(ticker, update: true)
            }
        }
    }
    
    /// Return all tickers cached in Realm
    func getAllTickers() -> Observable<[Ticker]> {
        // TODO: STUB
        return Observable.just([])
    }
    
    /// Get pinned tickers sorted by orderIndex
    func getPinnedTickers() -> Observable<Results<Ticker>> {
        let realm = try! Realm()
        
        let pinnedTickers = realm
            .objects(Ticker.self)
            .filter("isPinned = true")
        
        return Observable.collection(from: pinnedTickers)
    }
    
    /// Set ticker as pinned (show in menu bar)
    func pinTicker(symbol: String) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.create(Ticker.self, value: ["symbol": symbol, "isPinned": true], update: true)
        }
    }
    
    /// Unpin ticker (remove from menu bar)
    func unpinTicker(symbol: String) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.create(Ticker.self, value: ["symbol": symbol, "isPinned": false], update: true)
        }
    }
}
