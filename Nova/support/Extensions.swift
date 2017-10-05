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
//  Extensions.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Foundation
import Cocoa
import RealmSwift
import RxSwift

typealias RealmObject = Object

extension NSViewController {
    
    func setTransparentTitle() {
        self.view.window?.titleVisibility = .hidden
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = NSColor.clear
    }
}

extension NSColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension NSTextField {
    
    var cursorColor: NSColor? {
        
        get {
            if let fieldEditor = self.window?.fieldEditor(true, for: self) as? NSTextView {
                return fieldEditor.insertionPointColor
            }
            
            return nil
        }
        
        set {
            
            if let fieldEditor = self.window?.fieldEditor(true, for: self) as? NSTextView,
                let cursorColor = newValue {
                fieldEditor.insertionPointColor = cursorColor
            }
        }
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension ObservableType {
    public func retryWithDelay(timeInterval: Int) -> Observable<E> {
        return retryWhen { (attempts: Observable<Error>) -> Observable<Int> in
            return Observable
                .zip(attempts, Observable.just(timeInterval), resultSelector: { (o1, o2) in
                    return o2
                })
                .flatMap { i -> Observable<Int> in
                    return Observable.timer(RxTimeInterval(i), period: RxTimeInterval(i), scheduler: MainScheduler.instance)
                }
            }
    }
}
