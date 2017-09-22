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
//  Schedulers.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/22/17.
//


import Foundation
import RxSwift

class Schedulers {
    
    static var main: MainScheduler {
        return MainScheduler.instance
    }
    
    static var backgroundInteractive: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .userInteractive)
    }
    
    static var background: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    static var backgroundDefault: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .default)
    }
}
