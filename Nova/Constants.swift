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
//  Constants.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//
import Foundation
import Cocoa

/// Project constants
struct C {
    
    static let coinMarketCapBaseUrl = URL(string: "https://api.coinmarketcap.com/v1/")!
}

/// Resource constants
struct R {
    
    struct Color {
        static let primary = NSColor(rgb: 0x193C56)
        static let primaryLight = NSColor(rgb: 0xEEEEEB)
    }
    
    struct Id {
        
    }
    
    struct Font {
        
        static let menuBarTitleAttributes = [NSFontAttributeName: NSFont(name: "Avenir", size: 12.0)!]
    }
    
}
