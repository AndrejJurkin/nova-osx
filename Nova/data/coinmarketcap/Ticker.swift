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
import EVReflection

class Ticker: EVObject {
    
    var id: String = ""
    var name: String = ""
    var symbol: String = ""
    var rank: Int = 0
    var priceUsd: Double = 0
    var priceBtc: Double = 0
    var dailyVolume: Double = 0
    var marketCapUsd: Double = 0
    var availableSupply: Double = 0
    var totalSupply: Double = 0
    var changeLastHour: Float = 0
    var changeLastDay: Float = 0
    var changeLastWeek: Float = 0
    var lastUpdated: Double = 0
    
    var isPinned: Bool = false
    
    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [
            (keyInObject: "dailyVolume", keyInResource: "24h_volume_usd"),
            (keyInObject: "changeLastHour", keyInResource: "percent_change_1h"),
            (keyInObject: "changeLastDay", keyInResource: "percent_change_24h"),
            (keyInObject: "changeLastWeek", keyInResource: "percent_change_7d")
        ]
    }
    
}
