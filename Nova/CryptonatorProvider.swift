//
//  CryptonatorProvider.swift
//  Nova
//
//  Created by Andrej Jurkin on 12/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import Moya


enum CryptonatorProvider {
    
    case ticker(base: String, target: String)
}

extension CryptonatorProvider: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.cryptonator.com/api/")!
    }
    
    var path: String {
        switch self {
        case .ticker(let base, let target):
            return "ticker/\(base)-\(target)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
