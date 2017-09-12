//
//  CryptonatorTicker.swift
//  Nova
//
//  Created by Andrej Jurkin on 12/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import EVReflection

class CryptonatorTickerResponse: EVObject {
    
    var success: Bool = false
    
    var error: String = ""
    
    var timestamp: Int64 = 0
    
    var ticker: CryptonatorTicker?
}

class CryptonatorTicker: EVObject {
    
    var base: String = ""
    
    var target: String = ""
    
    var price: Double = 0
    
    var volume: Double = 0
    
    var change: Double = 0
}
