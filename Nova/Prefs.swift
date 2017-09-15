//
//  Prefs.swift
//  Nova
//
//  Created by Andrej Jurkin on 13/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
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
    /// - key: The currency symbol (ETH, BTC, etc.)
    /// - value: The latest price value
    var pinedCurrencies: [String: Double]? {
        
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
    
    private init() {
        
    }
}
