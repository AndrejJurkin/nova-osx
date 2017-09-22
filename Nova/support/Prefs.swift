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
//  Prefs.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Foundation

/// Class for accessing and modifying preference data
/// returned by NSUserDefaults.
///
/// All clients should use a shared instance of this class
class Prefs {
    
    static let shared = Prefs()
    
    /// Key values for acessing and modifying user defaults data
    struct Key {
        
        static let refreshInterval = "refresh_interval"
        
        static let pinnedSymbols = "pinned_symbols"
        
        static let targetCurrency = "target_currency"
    }
    
    let userDefaults = UserDefaults.standard
    
    /// Ticker refresh interval (seconds), default 30.0
    var rereshInterval: Float {
        
        get {
            return self.userDefaults.float(forKey: Key.refreshInterval)
        }
        
        set {
            self.userDefaults.set(newValue, forKey: Key.refreshInterval)
        }
    }
    
    /// Ticker symbols pinned to be displayed in menu bar
    ///
    /// - key: The currency symbol (ETH, BTC, etc.)
    /// - value: The latest price value
    ///
    /// Defaults to empty dictionry
    var pinedCurrencies: [String: Double] {
        
        get {
            if let value = self.userDefaults
                .dictionary(forKey: Key.pinnedSymbols) as? [String: Double] {
                
                return value
            }
            
            return [:]
        }
        
        set {
            self.userDefaults.set(newValue, forKey: Key.pinnedSymbols)
        }
    }
    
    /// Target currency to convert all coins into, default USD
    var targetCurrency: String {
        
        get {
            if let target = self.userDefaults.string(forKey: Key.targetCurrency) {
                return target
            }
            
            return "USD"
        }
        
        set {
            self.userDefaults.set(newValue, forKey: Key.targetCurrency)
        }
    }
    
    init() {
        
    }
}
