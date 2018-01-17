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
//  PriceFormatter.swift
//  Nova
//
//  Created by Andrej Jurkin on 10/29/17.
//

import Foundation

class PriceFormatter {
    
    let displaySymbol: String
    let displayCurrency: String
    let decimalFormat: String
    
    let decimalNumberFormatter: NumberFormatter
    
    init(displayCurrency: String, decimalFormat: String?) {
        self.displayCurrency = displayCurrency
        self.decimalFormat = decimalFormat != nil ? decimalFormat! : "auto"
        
        self.decimalNumberFormatter = NumberFormatter()
        decimalNumberFormatter.numberStyle = .decimal
        decimalNumberFormatter.groupingSeparator = ","
        decimalNumberFormatter.groupingSize = 3
        decimalNumberFormatter.minimumFractionDigits = 0
        decimalNumberFormatter.maximumFractionDigits = 0
        
        let locale = NSLocale(localeIdentifier: self.displayCurrency)
        self.displaySymbol = locale.displayName(
            forKey: NSLocale.Key.currencySymbol, value: self.displayCurrency) ?? displayCurrency
    }
    
    /// Format with ticker symbol (PAY 1.70)
    func formatWithTickerSymbol(ticker: Ticker) -> String {
        return self.format(ticker: ticker, symbol: ticker.symbol)
    }
    
    /// Format with target symbol ($ 1.70)
    func formatWithTargetSymbol(ticker: Ticker) -> String {
        return self.format(ticker: ticker, symbol: self.displaySymbol)
    }
    
    /// Format with provided symbol (SYMBOL PRICE)
    func format(ticker: Ticker, symbol: String) -> String {
        // significant digit formatting
        if self.decimalFormat.prefix(1) == "s" {
            let valueFormatter = NumberFormatter()
            valueFormatter.usesSignificantDigits = true
            var breakPoint: Double = 1000
            
            switch self.decimalFormat {
            // 3 significant digits
            case "s3":
                valueFormatter.minimumSignificantDigits = 3
                valueFormatter.maximumSignificantDigits = 3
                breakPoint = 1000
                break
            // 4 significant digits
            case "s4":
                valueFormatter.minimumSignificantDigits = 4
                valueFormatter.maximumSignificantDigits = 4
                breakPoint = 10000
                break
            // 5 significant digits
            case "s5":
                valueFormatter.minimumSignificantDigits = 5
                valueFormatter.maximumSignificantDigits = 5
                breakPoint = 100000
                break
            default:
                break
            }
            
            let price = ticker.price >= breakPoint ? ticker.price / 1000 : ticker.price
            return "\(symbol) \(String(format: ticker.price >= breakPoint ? "%@K" : "%@", valueFormatter.string(from: NSNumber(value: price))!))  "
        }
        
        let format = self.getPriceFormat(ticker: ticker)
        
        if displayCurrency == "SAT" {
            let satPrice = ticker.price * 100000000
            let formattedPrice = decimalNumberFormatter.string(for: satPrice) ?? "\(satPrice)"
            return "\(symbol) \(formattedPrice)  "
        }
        
        return "\(symbol) \(String(format: format, ticker.price))  "
    }
    
    func getPriceFormat(ticker: Ticker) -> String {
        switch self.decimalFormat {
        case "d0":
            return "%.0f"
        case "d1":
            return "%.1f"
        case "d2":
            return "%.2f"
        case "d3":
            return "%.3f"
        default:
            break
        }
        
        if self.displayCurrency == "BTC" {
            return "%.8f"
        } else if self.displayCurrency == "SAT" {
            return "%.0f"
        }
        
        return ticker.price < 1 ? "%.4f" : "%.2f"
    }
}
