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
//  Ticker.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Foundation
import RealmSwift
import ObjectMapper

class Ticker: RealmObject, Mappable {
    
    // Realm primary key
    dynamic var symbol: String = ""
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    dynamic var isPinned = false
    
    dynamic var priceUsd: Double = 0
    dynamic var priceBtc: Double = 0
    dynamic var rank: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        self.symbol <- map["symbol"]
        self.id <- map["id"]
        self.name <- map["name"]
        
        var priceUsdStr: String = ""
        var priceBtcStr: String = ""
        var rankStr: String = ""
        
        priceUsdStr <- map["price_usd"]
        priceBtcStr <- map["price_btc"]
        rankStr <- map["rank"]
        
        self.priceUsd = Double(priceUsdStr) ?? 0
        self.priceBtc = Double(priceBtcStr) ?? 0
        self.rank = Int(rankStr) ?? 0
    }
    
    override static func primaryKey() -> String? {
        return "symbol"
    }

    /// Update Realm with dictionary to prevent from overwriting ignored properties
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "symbol": symbol,
            "name": name,
            "priceUsd": priceUsd,
            "priceBtc": priceBtc,
            "rank": rank,
        ]
    }
}
