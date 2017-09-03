//
//  Ticker.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import EVReflection

class Ticker: EVObject {
    
    var id: String = ""
    var name: String = ""
    var symbol: String = ""
    var rank: Int = 0
    var priceUsd: Float = 0
    var priceBtc: Float = 0
    var dailyVolume: Double = 0
    var marketCapUsd: Double = 0
    var availableSupply: Double = 0
    var totalSupply: Double = 0
    var percentChange1h: Float = 0
    var percentChange24h: Float = 0
    var percentChange7d: Float = 0
    var lastUpdate: Double = 0
    
    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [(keyInObject: "dailyVolume", keyInResource: "24h_volume_usd")]
    }
    
}
