//
//  CoinMarketCapService.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/2/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import Moya

enum CoinMarketCapProvider {
    
    case allTickers
    
    case ticker(currencyName: String)
}

extension CoinMarketCapProvider: TargetType {
    
    var baseURL: URL {
        return C.coinMarketCapBaseUrl
    }
    
    var path: String {
        switch self {
        case .allTickers:
            return "ticker"
        case .ticker(let currencyName):
            return "ticker/\(currencyName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        return nil
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
