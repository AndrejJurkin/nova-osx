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
//  CryptonatorTickerr.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/22/17.
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
