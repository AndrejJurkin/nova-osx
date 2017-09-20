//
//  Schedulers.swift
//  Nova
//
//  Created by Andrej Jurkin on 20/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
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
